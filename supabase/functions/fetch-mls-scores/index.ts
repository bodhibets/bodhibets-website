// Supabase Edge Function: fetch-mls-scores
// Runs nightly at 12:30 AM CDT to fetch final MLS scores from API-Sports
// and insert them into the mls_game_results table

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const API_SPORTS_KEY = Deno.env.get('API_SPORTS_KEY')!
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY)

  // Get yesterday's date in YYYY-MM-DD format (games that just ended)
  const yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1)
  const dateStr = yesterday.toISOString().split('T')[0]

  try {
    // Fetch MLS fixtures for the date from API-Sports
    // MLS league_id = 253
    const response = await fetch(
      `https://v3.football.api-sports.io/fixtures?league=253&season=2026&date=${dateStr}`,
      {
        headers: {
          'x-apisports-key': API_SPORTS_KEY,
        },
      }
    )

    const data = await response.json()
    const fixtures = data.response

    if (!fixtures || fixtures.length === 0) {
      return new Response(JSON.stringify({ message: 'No MLS fixtures found', date: dateStr }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Map API response to our schema
    const results = fixtures
      .filter((f: any) => f.fixture.status.short === 'FT') // Only finished games
      .map((f: any) => ({
        fixture_id: f.fixture.id.toString(),
        game_date: dateStr,
        home_team: f.teams.home.name,
        away_team: f.teams.away.name,
        home_score: f.goals.home,
        away_score: f.goals.away,
        status: 'FT',
        league: 'MLS',
        season: 2026,
        fetched_at: new Date().toISOString(),
      }))

    if (results.length === 0) {
      return new Response(JSON.stringify({ message: 'No finished MLS games yet', date: dateStr }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Upsert into Supabase (won't duplicate on re-run)
    const { error } = await supabase
      .from('mls_game_results')
      .upsert(results, { onConflict: 'fixture_id' })

    if (error) throw error

    return new Response(
      JSON.stringify({ success: true, inserted: results.length, date: dateStr }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})
