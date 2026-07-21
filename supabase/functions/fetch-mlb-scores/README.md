# fetch-mlb-scores

Supabase Edge Function that auto-fetches final MLB scores from API-Sports nightly.

## Schedule
Runs at 12:30 AM CDT every day via Supabase cron.

## Environment Variables Required
Set these in Supabase Dashboard → Project Settings → Edge Functions → Secrets:

```
API_SPORTS_KEY=your_key_here
SUPABASE_URL=your_supabase_project_url
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

## Manual Trigger
You can manually invoke this function from Supabase Dashboard → Edge Functions → fetch-mlb-scores → Invoke.

## Table
Inserts into: `mlb_game_results`
Conflict key: `game_id` (safe to re-run, no duplicates)
