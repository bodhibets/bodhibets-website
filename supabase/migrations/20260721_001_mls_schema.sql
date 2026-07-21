-- ============================================================
-- BodhiBets MLS Schema Migration
-- Project: d20dc2bc2a4542bd3469cbb563eae84e
-- Created: 2026-07-21
-- ============================================================

-- ────────────────────────────────────────
-- EXTENSIONS
-- ────────────────────────────────────────
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";

-- ────────────────────────────────────────
-- TEAMS
-- ────────────────────────────────────────
create table if not exists mls_teams (
  id            uuid primary key default uuid_generate_v4(),
  team_name     text not null,
  abbreviation  text not null unique,
  conference    text not null check (conference in ('Eastern', 'Western')),
  city          text not null,
  stadium       text,
  created_at    timestamptz default now()
);

-- ────────────────────────────────────────
-- GAMES
-- ────────────────────────────────────────
create table if not exists mls_games (
  id              uuid primary key default uuid_generate_v4(),
  game_date       date not null,
  kickoff_time    time,
  home_team_id    uuid references mls_teams(id),
  away_team_id    uuid references mls_teams(id),
  home_score      int,
  away_score      int,
  status          text default 'scheduled' check (status in ('scheduled','live','final','postponed')),
  season          int not null default 2026,
  matchweek       int,
  venue           text,
  created_at      timestamptz default now()
);

create index if not exists idx_mls_games_date on mls_games(game_date);
create index if not exists idx_mls_games_status on mls_games(status);

-- ────────────────────────────────────────
-- ODDS
-- ────────────────────────────────────────
create table if not exists mls_odds (
  id              uuid primary key default uuid_generate_v4(),
  game_id         uuid references mls_games(id) on delete cascade,
  book            text not null,
  market          text not null,  -- 'ml','spread','ou','btts','dnb'
  home_line       numeric(6,2),
  away_line       numeric(6,2),
  draw_line       numeric(6,2),
  over_line       numeric(6,2),
  under_line      numeric(6,2),
  total           numeric(4,1),
  spread          numeric(4,1),
  recorded_at     timestamptz default now(),
  is_opening      boolean default false,
  created_at      timestamptz default now()
);

create index if not exists idx_mls_odds_game on mls_odds(game_id);
create index if not exists idx_mls_odds_book on mls_odds(book);

-- ────────────────────────────────────────
-- PICKS
-- ────────────────────────────────────────
create table if not exists mls_picks (
  id              uuid primary key default uuid_generate_v4(),
  game_id         uuid references mls_games(id),
  pick_side       text not null,   -- team abbreviation or 'over'/'under'
  market          text not null,
  line_at_pick    numeric(6,2),
  confidence      int check (confidence between 1 and 10),
  edge_pct        numeric(5,2),
  unit_size       numeric(4,2),
  result          text check (result in ('win','loss','push','pending')) default 'pending',
  profit_loss     numeric(8,2),
  published       boolean default false,
  pick_date       date not null default current_date,
  notes           text,
  created_at      timestamptz default now()
);

create index if not exists idx_mls_picks_date on mls_picks(pick_date);
create index if not exists idx_mls_picks_result on mls_picks(result);

-- ────────────────────────────────────────
-- STANDINGS
-- ────────────────────────────────────────
create table if not exists mls_standings (
  id              uuid primary key default uuid_generate_v4(),
  team_id         uuid references mls_teams(id),
  season          int not null default 2026,
  conference_rank int,
  overall_rank    int,
  gp              int default 0,
  wins            int default 0,
  draws           int default 0,
  losses          int default 0,
  goals_for       int default 0,
  goals_against   int default 0,
  goal_diff       int generated always as (goals_for - goals_against) stored,
  points          int generated always as ((wins * 3) + draws) stored,
  ppg             numeric(4,2),
  form            text,  -- last 5 e.g. 'WWDLW'
  updated_at      timestamptz default now(),
  unique(team_id, season)
);

-- ────────────────────────────────────────
-- SUBSCRIBER POSTS
-- ────────────────────────────────────────
create table if not exists subscriber_posts (
  id              uuid primary key default uuid_generate_v4(),
  post_date       date not null default current_date,
  sport           text not null default 'MLS',
  title           text,
  body            text,
  picks           jsonb,  -- array of pick IDs included
  platform        text,   -- 'substack','twitter','discord'
  bitly_url       text,
  bitly_clicks    int default 0,
  published_at    timestamptz,
  created_at      timestamptz default now()
);

-- ────────────────────────────────────────
-- CONFIDENCE BRIEFS (internal)
-- ────────────────────────────────────────
create table if not exists confidence_briefs (
  id              uuid primary key default uuid_generate_v4(),
  brief_date      date not null default current_date,
  sport           text not null default 'MLS',
  slate_size      int,
  unit_size       numeric(4,2),
  posting_window  text,
  threshold_min   int,
  cards           jsonb,  -- array of per-pick confidence data
  summary         text,
  created_at      timestamptz default now()
);

-- ────────────────────────────────────────
-- TRACKING (Bitly + engagement)
-- ────────────────────────────────────────
create table if not exists link_tracking (
  id              uuid primary key default uuid_generate_v4(),
  post_id         uuid references subscriber_posts(id),
  bitly_id        text,
  long_url        text,
  short_url       text,
  clicks          int default 0,
  platform        text,
  tracked_at      timestamptz default now()
);

-- ────────────────────────────────────────
-- VIEWS
-- ────────────────────────────────────────
create or replace view v_upcoming_games as
  select
    g.id,
    g.game_date,
    g.kickoff_time,
    h.team_name as home_team,
    h.abbreviation as home_abbr,
    a.team_name as away_team,
    a.abbreviation as away_abbr,
    g.status,
    g.matchweek
  from mls_games g
  join mls_teams h on g.home_team_id = h.id
  join mls_teams a on g.away_team_id = a.id
  where g.game_date >= current_date
  order by g.game_date, g.kickoff_time;

create or replace view v_picks_record as
  select
    result,
    count(*) as total,
    round(avg(confidence), 1) as avg_confidence,
    sum(profit_loss) as total_pl,
    round(sum(unit_size), 2) as total_units_risked
  from mls_picks
  group by result;

create or replace view v_daily_slate as
  select
    g.game_date,
    h.abbreviation as home,
    a.abbreviation as away,
    o.book,
    o.home_line,
    o.away_line,
    o.draw_line,
    o.total,
    o.over_line,
    o.under_line,
    p.pick_side,
    p.confidence,
    p.unit_size,
    p.result
  from mls_games g
  join mls_teams h on g.home_team_id = h.id
  join mls_teams a on g.away_team_id = a.id
  left join mls_odds o on o.game_id = g.id
  left join mls_picks p on p.game_id = g.id
  where g.game_date = current_date
  order by g.kickoff_time;

-- ────────────────────────────────────────
-- ROW LEVEL SECURITY
-- ────────────────────────────────────────
alter table mls_teams enable row level security;
alter table mls_games enable row level security;
alter table mls_odds enable row level security;
alter table mls_picks enable row level security;
alter table mls_standings enable row level security;
alter table subscriber_posts enable row level security;
alter table confidence_briefs enable row level security;
alter table link_tracking enable row level security;

-- Public read on teams, games, standings
create policy "public_read_teams" on mls_teams for select using (true);
create policy "public_read_games" on mls_games for select using (true);
create policy "public_read_standings" on mls_standings for select using (true);

-- Authenticated only for everything else
create policy "auth_all_odds" on mls_odds using (auth.role() = 'authenticated');
create policy "auth_all_picks" on mls_picks using (auth.role() = 'authenticated');
create policy "auth_all_posts" on subscriber_posts using (auth.role() = 'authenticated');
create policy "auth_all_briefs" on confidence_briefs using (auth.role() = 'authenticated');
create policy "auth_all_tracking" on link_tracking using (auth.role() = 'authenticated');
