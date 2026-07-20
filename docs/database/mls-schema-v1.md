# MLS Database Schema — Bodhi Bets
*Version 1.0 | Created: July 20, 2026*

---

## TABLE 1: mls_teams
Stores all MLS team reference data.

```sql
CREATE TABLE mls_teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  team_name TEXT NOT NULL,
  abbreviation TEXT NOT NULL,
  conference TEXT CHECK (conference IN ('Eastern', 'Western')),
  city TEXT,
  stadium TEXT,
  home_field_advantage DECIMAL(4,2),  -- historical HFA %
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## TABLE 2: mls_fixtures
Stores every MLS match with slate info.

```sql
CREATE TABLE mls_fixtures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  game_date DATE NOT NULL,
  kickoff_time TIMESTAMPTZ NOT NULL,
  home_team_id UUID REFERENCES mls_teams(id),
  away_team_id UUID REFERENCES mls_teams(id),
  venue TEXT,
  is_home_neutral BOOLEAN DEFAULT FALSE,
  league_week INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## TABLE 3: mls_odds
Stores live + opening odds per fixture.

```sql
CREATE TABLE mls_odds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fixture_id UUID REFERENCES mls_fixtures(id),
  sportsbook TEXT,                     -- e.g. 'DraftKings', 'FanDuel'
  home_ml INTEGER,                     -- e.g. -150
  away_ml INTEGER,                     -- e.g. +130
  draw_ml INTEGER,                     -- e.g. +260
  home_spread DECIMAL(4,1),            -- e.g. -0.5
  away_spread DECIMAL(4,1),
  spread_juice_home INTEGER,
  spread_juice_away INTEGER,
  total_goals DECIMAL(4,1),            -- e.g. 2.5
  over_juice INTEGER,
  under_juice INTEGER,
  odds_type TEXT CHECK (odds_type IN ('opening', 'current', 'closing')),
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## TABLE 4: mls_polymarket
Stores Polymarket win probabilities per fixture.

```sql
CREATE TABLE mls_polymarket (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fixture_id UUID REFERENCES mls_fixtures(id),
  home_win_pct DECIMAL(5,2),           -- e.g. 52.30
  away_win_pct DECIMAL(5,2),
  draw_pct DECIMAL(5,2),
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## TABLE 5: mls_model_output
Stores Bodhi Double-Decker model results per fixture.

```sql
CREATE TABLE mls_model_output (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fixture_id UUID REFERENCES mls_fixtures(id),
  bodhi_home_win_pct DECIMAL(5,2),     -- Bodhi Blend
  bodhi_away_win_pct DECIMAL(5,2),
  bodhi_draw_pct DECIMAL(5,2),
  home_edge DECIMAL(5,2),              -- Bodhi Blend % minus implied odds %
  away_edge DECIMAL(5,2),
  confidence_score INTEGER,            -- 0-100
  recommended_bet TEXT,                -- e.g. 'HOME ML', 'DRAW', 'UNDER 2.5', 'FADE'
  bet_line TEXT,                       -- e.g. '-130'
  unit_size DECIMAL(4,2),              -- e.g. 1.5
  publish_flag BOOLEAN DEFAULT FALSE,  -- TRUE = meets 70+ conf + 2%+ edge threshold
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## TABLE 6: mls_results
Stores final scores for hit rate tracking.

```sql
CREATE TABLE mls_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fixture_id UUID REFERENCES mls_fixtures(id),
  home_score INTEGER,
  away_score INTEGER,
  result TEXT CHECK (result IN ('HOME', 'AWAY', 'DRAW')),
  total_goals INTEGER,
  recorded_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## TABLE 7: mls_picks_log
Tracks every published pick for hit rate and ROI.

```sql
CREATE TABLE mls_picks_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fixture_id UUID REFERENCES mls_fixtures(id),
  model_output_id UUID REFERENCES mls_model_output(id),
  bet_type TEXT,                       -- 'ML', 'SPREAD', 'TOTAL', 'PARLAY'
  pick TEXT,                           -- e.g. 'HOME ML -130'
  units DECIMAL(4,2),
  confidence_score INTEGER,
  result TEXT CHECK (result IN ('WIN', 'LOSS', 'PUSH', 'PENDING')),
  profit_loss DECIMAL(6,2),            -- in units
  published_at TIMESTAMPTZ,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## INDEXES
```sql
CREATE INDEX idx_mls_fixtures_date ON mls_fixtures(game_date);
CREATE INDEX idx_mls_odds_fixture ON mls_odds(fixture_id);
CREATE INDEX idx_mls_model_publish ON mls_model_output(publish_flag, confidence_score);
CREATE INDEX idx_mls_picks_result ON mls_picks_log(result);
```

---

## NEXT STEPS
1. Run this schema in Supabase SQL editor
2. Seed mls_teams table with all 30 MLS teams
3. Pull July 22 fixture data and seed mls_fixtures
4. Wire Polymarket + sportsbook odds to mls_odds + mls_polymarket tables
5. Run model output for July 22 slate

---

*Last updated: July 20, 2026*
