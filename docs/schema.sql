-- ============================================================
-- BODHI BETS | Supabase Schema
-- Version: 1.0 | Created: 2026-07-20
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- TABLE: traders
-- Profiles for trusted external bettors / Polymarket wallets
-- ============================================================
CREATE TABLE traders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  handle TEXT NOT NULL UNIQUE,           -- display name or wallet address
  platform TEXT NOT NULL,                -- 'polymarket' | 'twitter' | 'internal'
  trader_score NUMERIC(5,2) DEFAULT 50,  -- 0-100, updated after each settled block
  total_picks INTEGER DEFAULT 0,
  total_wins INTEGER DEFAULT 0,
  win_rate NUMERIC(5,4),                 -- calculated: wins/picks
  avg_roi NUMERIC(7,4),                  -- running average ROI
  notes TEXT,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: daily_blocks
-- One row per day. The master record for each block.
-- ============================================================
CREATE TABLE daily_blocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  block_date DATE NOT NULL UNIQUE,       -- e.g. '2026-07-20'
  league TEXT NOT NULL DEFAULT 'MLB',
  game_count INTEGER DEFAULT 0,
  games_analyzed INTEGER DEFAULT 0,
  picks_generated INTEGER DEFAULT 0,
  top_confidence NUMERIC(5,2),           -- highest confidence score that day
  block_status TEXT DEFAULT 'OPEN',      -- 'OPEN' | 'LOCKED' | 'SETTLED'
  final_status TEXT,                     -- 'WIN' | 'LOSS' | 'PUSH' | 'MIXED'
  roi_for_day NUMERIC(7,4),             -- calculated after results settled
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  locked_at TIMESTAMPTZ,
  settled_at TIMESTAMPTZ
);

-- ============================================================
-- TABLE: events
-- One row per game on the slate
-- ============================================================
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  block_date DATE NOT NULL REFERENCES daily_blocks(block_date),
  league TEXT NOT NULL DEFAULT 'MLB',
  home_team TEXT NOT NULL,
  away_team TEXT NOT NULL,
  venue TEXT,
  first_pitch_ct TIMETZ,                 -- Central Time
  home_starter TEXT,
  away_starter TEXT,
  home_starter_confirmed BOOLEAN DEFAULT FALSE,
  away_starter_confirmed BOOLEAN DEFAULT FALSE,
  weather_flag BOOLEAN DEFAULT FALSE,
  weather_notes TEXT,                    -- 'Wind 18mph out to LF', etc.
  event_status TEXT DEFAULT 'scheduled', -- 'scheduled' | 'final' | 'postponed'
  home_final_score INTEGER,
  away_final_score INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: markets
-- Lines and odds for each event
-- ============================================================
CREATE TABLE markets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id),
  market_type TEXT NOT NULL,             -- 'ML' | 'RL' | 'TOTAL' | 'NRFI' | 'YRFI'
  home_line NUMERIC(6,2),               -- ML: -150, RL: -110, etc.
  away_line NUMERIC(6,2),
  total_line NUMERIC(4,1),              -- e.g. 8.5
  over_juice NUMERIC(6,2),
  under_juice NUMERIC(6,2),
  opening_home_line NUMERIC(6,2),       -- for tracking line movement
  opening_away_line NUMERIC(6,2),
  line_movement_flag BOOLEAN DEFAULT FALSE,
  sharp_action_flag BOOLEAN DEFAULT FALSE,
  pct_bets_home NUMERIC(5,2),          -- % of public bets on home team
  pct_money_home NUMERIC(5,2),         -- % of money on home team
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: external_signals
-- Trader positions and external market signals
-- ============================================================
CREATE TABLE external_signals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id),
  trader_id UUID REFERENCES traders(id),
  market_type TEXT NOT NULL,
  side TEXT NOT NULL,                    -- 'HOME' | 'AWAY' | 'OVER' | 'UNDER'
  entry_price NUMERIC(5,4),             -- Polymarket: 0.62 = 62 cents
  stake_pct NUMERIC(5,2),              -- % of trader's bankroll in this position
  is_holder BOOLEAN DEFAULT FALSE,      -- TRUE = holding large into game time
  source TEXT DEFAULT 'polymarket',     -- 'polymarket' | 'sharp' | 'manual'
  signal_strength NUMERIC(5,2),        -- 0-100
  notes TEXT,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: internal_signals
-- Model outputs for each event
-- ============================================================
CREATE TABLE internal_signals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id),
  market_type TEXT NOT NULL,
  model_side TEXT NOT NULL,             -- 'HOME' | 'AWAY' | 'OVER' | 'UNDER'
  model_win_prob NUMERIC(5,4),         -- model's win probability (e.g. 0.587)
  implied_prob NUMERIC(5,4),           -- from moneyline
  edge_pct NUMERIC(5,2),              -- model_prob - implied_prob * 100
  confidence_score NUMERIC(5,2),       -- 0-100
  -- Pitching inputs
  home_starter_era NUMERIC(4,2),
  home_starter_fip NUMERIC(4,2),
  home_starter_xfip NUMERIC(4,2),
  away_starter_era NUMERIC(4,2),
  away_starter_fip NUMERIC(4,2),
  away_starter_xfip NUMERIC(4,2),
  -- Offensive inputs
  home_wrc_plus INTEGER,
  away_wrc_plus INTEGER,
  home_runs_per_game_l10 NUMERIC(4,2),
  away_runs_per_game_l10 NUMERIC(4,2),
  -- Situational
  h2h_record TEXT,                     -- e.g. '4-2 HOU this season'
  travel_fatigue_flag BOOLEAN DEFAULT FALSE,
  bullpen_fatigue_flag BOOLEAN DEFAULT FALSE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: consensus_views
-- Alignment matrix: internal vs external per game/market
-- ============================================================
CREATE TABLE consensus_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id),
  market_type TEXT NOT NULL,
  internal_side TEXT,
  external_side TEXT,
  alignment TEXT NOT NULL,              -- 'ALIGNED' | 'CONFLICT' | 'EXTERNAL_ONLY'
  trader_count INTEGER DEFAULT 0,       -- # of top traders on same side
  weighted_signal NUMERIC(5,2),        -- weighted consensus strength 0-100
  final_confidence NUMERIC(5,2),       -- combined confidence score
  pick_eligible BOOLEAN DEFAULT FALSE,  -- passes all filters
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: final_plays
-- The picks generated for each day
-- ============================================================
CREATE TABLE final_plays (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  block_date DATE NOT NULL REFERENCES daily_blocks(block_date),
  event_id UUID NOT NULL REFERENCES events(id),
  play_type TEXT NOT NULL,              -- 'LOCK' | '2LEG' | '3LEG' | 'MEGA'
  market_type TEXT NOT NULL,
  side TEXT NOT NULL,
  line NUMERIC(6,2),
  confidence_score NUMERIC(5,2),
  edge_pct NUMERIC(5,2),
  parlay_leg_number INTEGER,           -- 1, 2, 3... for parlay legs
  parlay_id UUID,                      -- links legs of same parlay together
  recommended_units NUMERIC(4,2),      -- e.g. 1.5 = 1.5 units
  reasoning TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- TABLE: play_results
-- Historical outcomes for every pick
-- ============================================================
CREATE TABLE play_results (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  play_id UUID NOT NULL REFERENCES final_plays(id),
  result TEXT NOT NULL,                 -- 'WIN' | 'LOSS' | 'PUSH' | 'NO_ACTION'
  actual_home_score INTEGER,
  actual_away_score INTEGER,
  closing_line NUMERIC(6,2),           -- for CLV tracking
  clv_edge NUMERIC(5,2),              -- closing line value
  profit_units NUMERIC(6,3),          -- units won/lost
  notes TEXT,
  settled_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX idx_events_block_date ON events(block_date);
CREATE INDEX idx_markets_event_id ON markets(event_id);
CREATE INDEX idx_external_signals_event_id ON external_signals(event_id);
CREATE INDEX idx_internal_signals_event_id ON internal_signals(event_id);
CREATE INDEX idx_consensus_views_event_id ON consensus_views(event_id);
CREATE INDEX idx_final_plays_block_date ON final_plays(block_date);
CREATE INDEX idx_play_results_play_id ON play_results(play_id);

-- ============================================================
-- ROW LEVEL SECURITY (enable after testing)
-- ============================================================
-- ALTER TABLE traders ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE daily_blocks ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE events ENABLE ROW LEVEL SECURITY;
-- (Apply policies per your auth setup)

-- ============================================================
-- END OF SCHEMA
-- Bodhi Bets | Built different. Research-first. Always.
-- ============================================================
