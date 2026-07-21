-- Migration: Create game results tables for MLS and MLB
-- Auto-populated nightly by Edge Functions

-- MLS Game Results
CREATE TABLE IF NOT EXISTS mls_game_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  fixture_id TEXT UNIQUE NOT NULL,
  game_date DATE NOT NULL,
  home_team TEXT NOT NULL,
  away_team TEXT NOT NULL,
  home_score INTEGER,
  away_score INTEGER,
  status TEXT DEFAULT 'FT',
  league TEXT DEFAULT 'MLS',
  season INTEGER DEFAULT 2026,
  fetched_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- MLB Game Results
CREATE TABLE IF NOT EXISTS mlb_game_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  game_id TEXT UNIQUE NOT NULL,
  game_date DATE NOT NULL,
  home_team TEXT NOT NULL,
  away_team TEXT NOT NULL,
  home_score INTEGER,
  away_score INTEGER,
  status TEXT DEFAULT 'FT',
  league TEXT DEFAULT 'MLB',
  season INTEGER DEFAULT 2026,
  fetched_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast date queries
CREATE INDEX IF NOT EXISTS idx_mls_results_date ON mls_game_results(game_date);
CREATE INDEX IF NOT EXISTS idx_mlb_results_date ON mlb_game_results(game_date);

-- Schedule cron jobs (runs at 5:30 AM UTC = 12:30 AM CDT)
-- Requires pg_cron extension enabled in Supabase
SELECT cron.schedule(
  'fetch-mls-scores-nightly',
  '30 5 * * *',
  $$SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/fetch-mls-scores',
    headers := jsonb_build_object('Authorization', 'Bearer ' || current_setting('app.service_role_key'))
  )$$
);

SELECT cron.schedule(
  'fetch-mlb-scores-nightly',
  '30 5 * * *',
  $$SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/fetch-mlb-scores',
    headers := jsonb_build_object('Authorization', 'Bearer ' || current_setting('app.service_role_key'))
  )$$
);
