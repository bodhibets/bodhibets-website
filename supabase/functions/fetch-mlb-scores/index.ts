// Supabase Edge Function: fetch-mlb-scores
// Runs nightly at 12:30 AM CDT to fetch final MLB scores from API-Sports
// and insert them into the mlb_game_results table

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const API_SPORTS_KEY = Deno.env.get('API_SPORTS_KEY')!
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY)

  const yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1)
  const dateStr = yesterday.toISOString().split('T')[0]

  try {
    // Fetch MLB games for the date from API-Sports
    // MLB league_id = 1 on api-sports baseball endpoint
    const response = await fetch(
      `https://v1.baseball.api-sports.io/games?league=1&season=2026&date=${dateStr}`,
      {
        headers: {
          'x-apisports-key': API_SPORTS_KEY,
        },
      }
    )

    const data = await response.json()
    const games = data.response

    if (!games || games.length === 0) {
      return new Response(JSON.stringify({ message: 'No MLB games found', date: dateStr }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const results = games
      .filter((g: any) => g.status.short === 'FT')
      .map((g: any) => ({
        game_id: g.id.toString(),
        game_date: dateStr,
        home_team: g.teams.home.name,
        away_team: g.teams.away.name,
        home_score: g.scores.home.total,
        away_score: g.scores.away.total,
        status: 'FT',
        league: 'MLB',
        season: 2026,
        fetched_at: new Date().toISOString(),
      }))

    if (results.length === 0) {
      return new Response(JSON.stringify({ message: 'No finished MLB games yet', date: dateStr }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const { error } = await supabase
      .from('mlb_game_results')
      .upsert(results, { onConflict: 'game_id' })

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
