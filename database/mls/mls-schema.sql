-- ============================================================
-- BODHI BETS | MLS DATABASE SCHEMA
-- Supabase SQL Editor | Created: July 20, 2026
-- Paste this entire block into your Supabase SQL editor
-- ============================================================

-- 1. TEAMS TABLE
create table if not exists mls_teams (
  id serial primary key,
  team_code text unique not null,
  team_name text not null,
  conference text check (conference in ('Eastern', 'Western')),
  home_stadium text,
  stadium_type text check (stadium_type in ('Indoor', 'Outdoor', 'Dome')),
  city text,
  state text,
  created_at timestamptz default now()
);

-- 2. STANDINGS TABLE (updated daily)
create table if not exists mls_standings (
  id serial primary key,
  team_code text references mls_teams(team_code),
  season int default 2026,
  games_played int default 0,
  wins int default 0,
  losses int default 0,
  draws int default 0,
  goals_for int default 0,
  goals_against int default 0,
  goal_differential int generated always as (goals_for - goals_against) stored,
  points int generated always as ((wins * 3) + draws) stored,
  home_record text,
  away_record text,
  last_updated date default current_date,
  unique(team_code, season)
);

-- 3. FIXTURES TABLE
create table if not exists mls_fixtures (
  id serial primary key,
  game_date date not null,
  kickoff_time_ct text,
  home_team text references mls_teams(team_code),
  away_team text references mls_teams(team_code),
  venue text,
  tv_network text,
  season int default 2026,
  matchweek int,
  created_at timestamptz default now()
);

-- 4. ODDS TABLE
create table if not exists mls_odds (
  id serial primary key,
  fixture_id int references mls_fixtures(id),
  recorded_at timestamptz default now(),
  home_ml numeric,
  away_ml numeric,
  draw_ml numeric,
  home_spread numeric,
  away_spread numeric,
  spread_juice_home numeric,
  spread_juice_away numeric,
  total_goals numeric,
  over_juice numeric,
  under_juice numeric,
  sportsbook text default 'BetMGM'
);

-- 5. POLYMARKET TABLE
create table if not exists mls_polymarket (
  id serial primary key,
  fixture_id int references mls_fixtures(id),
  recorded_at timestamptz default now(),
  home_win_pct numeric,
  away_win_pct numeric,
  draw_pct numeric,
  market_volume numeric,
  conflict_flag boolean default false
);

-- 6. BODHI MODEL TABLE
create table if not exists mls_model (
  id serial primary key,
  fixture_id int references mls_fixtures(id),
  run_at timestamptz default now(),
  home_book_implied numeric,
  away_book_implied numeric,
  home_poly_pct numeric,
  away_poly_pct numeric,
  home_bodhi_blend numeric,
  away_bodhi_blend numeric,
  home_edge numeric,
  away_edge numeric,
  home_confidence int,
  away_confidence int,
  publish_home boolean default false,
  publish_away boolean default false,
  conflict_flag boolean default false,
  notes text
);

-- 7. PICKS TABLE
create table if not exists mls_picks (
  id serial primary key,
  fixture_id int references mls_fixtures(id),
  pick_date date default current_date,
  pick_type text check (pick_type in ('ML','Spread','Total','Both Teams to Score','Correct Score','First Goal','Prop','Fade','Parlay Leg')),
  pick_side text,
  pick_team text references mls_teams(team_code),
  pick_line numeric,
  pick_juice numeric,
  confidence int,
  edge numeric,
  units numeric,
  parlay_id int,
  published boolean default false,
  result text check (result in ('Win','Loss','Push','Pending')),
  created_at timestamptz default now()
);

-- 8. PARLAYS TABLE
create table if not exists mls_parlays (
  id serial primary key,
  parlay_date date default current_date,
  parlay_type text check (parlay_type in ('2-Leg','3-Leg','4-Leg','Mega')),
  estimated_payout text,
  units numeric,
  hit_rate_pct numeric,
  result text check (result in ('Win','Loss','Pending')),
  created_at timestamptz default now()
);

-- 9. POST-SLATE REVIEW TABLE
create table if not exists mls_review (
  id serial primary key,
  review_date date default current_date,
  net_units numeric,
  biggest_miss text,
  model_adjustment text,
  conflict_validated boolean,
  notes text,
  created_at timestamptz default now()
);

-- ============================================================
-- SEED: ALL 30 MLS TEAMS
-- ============================================================
insert into mls_teams (team_code, team_name, conference, home_stadium, stadium_type, city, state) values
('NSH','Nashville SC','Eastern','Geodis Park','Outdoor','Nashville','TN'),
('MIA','Inter Miami CF','Eastern','Nu Stadium','Outdoor','Miami','FL'),
('CHI','Chicago Fire FC','Eastern','Soldier Field','Outdoor','Chicago','IL'),
('NE','New England Revolution','Eastern','Boston Stadium','Outdoor','Foxborough','MA'),
('RBNY','New York Red Bulls','Eastern','Red Bull Arena','Outdoor','Harrison','NJ'),
('CLT','Charlotte FC','Eastern','Bank of America Stadium','Outdoor','Charlotte','NC'),
('CIN','FC Cincinnati','Eastern','TQL Stadium','Outdoor','Cincinnati','OH'),
('NYC','New York City FC','Eastern','Yankee Stadium','Outdoor','New York','NY'),
('DC','D.C. United','Eastern','Audi Field','Outdoor','Washington','DC'),
('CLB','Columbus Crew SC','Eastern','ScottsMiracle-Gro Field','Outdoor','Columbus','OH'),
('MTL','CF Montreal','Eastern','Saputo Stadium','Outdoor','Montreal','QC'),
('TOR','Toronto FC','Eastern','BMO Field','Outdoor','Toronto','ON'),
('ATL','Atlanta United FC','Eastern','Mercedes-Benz Stadium','Dome','Atlanta','GA'),
('ORL','Orlando City SC','Eastern','Inter&Co Stadium','Outdoor','Orlando','FL'),
('PHI','Philadelphia Union','Eastern','Subaru Park','Outdoor','Chester','PA'),
('VAN','Vancouver Whitecaps FC','Western','BC Place','Dome','Vancouver','BC'),
('SJ','San Jose Earthquakes','Western','PayPal Park','Outdoor','San Jose','CA'),
('LAFC','Los Angeles Football Club','Western','BMO Stadium','Outdoor','Los Angeles','CA'),
('RSL','Real Salt Lake','Western','America First Field','Outdoor','Sandy','UT'),
('DAL','FC Dallas','Western','Toyota Stadium','Outdoor','Frisco','TX'),
('HOU','Houston Dynamo','Western','Shell Energy Stadium','Outdoor','Houston','TX'),
('COL','Colorado Rapids','Western','Dicks Sporting Goods Park','Outdoor','Commerce City','CO'),
('LA','LA Galaxy','Western','Dignity Health Sports Park','Outdoor','Carson','CA'),
('ATX','Austin FC','Western','Q2 Stadium','Outdoor','Austin','TX'),
('SAN','San Diego FC','Western','Snapdragon Stadium','Outdoor','San Diego','CA'),
('POR','Portland Timbers','Western','Providence Park','Outdoor','Portland','OR'),
('STL','St. Louis City SC','Western','CityPark','Outdoor','St. Louis','MO'),
('SKC','Sporting Kansas City','Western','Sporting Park','Outdoor','Kansas City','KS'),
('MIN','Minnesota United FC','Western','Allianz Field','Outdoor','St. Paul','MN'),
('SEA','Seattle Sounders FC','Western','Lumen Field','Outdoor','Seattle','WA')
on conflict (team_code) do nothing;

-- ============================================================
-- SEED: JULY 22 FIXTURES (15 games, Matchweek 16)
-- ============================================================
insert into mls_fixtures (game_date, kickoff_time_ct, home_team, away_team, venue, tv_network, matchweek) values
('2026-07-22','11:30 PM','CIN','VAN','TQL Stadium, Cincinnati, OH','Apple TV',16),
('2026-07-22','11:30 PM','CLB','NYC','ScottsMiracle-Gro Field, Columbus, OH','Apple TV',16),
('2026-07-22','11:30 PM','MIA','CHI','Nu Stadium, Miami, FL','Apple TV',16),
('2026-07-22','11:30 PM','NE','TOR','Boston Stadium, Foxborough, MA','Apple TV',16),
('2026-07-22','11:30 PM','PHI','RBNY','Subaru Park, Chester, PA','Apple TV',16),
('2026-07-23','12:15 AM','CLT','ATL','Bank of America Stadium, Charlotte, NC','Apple TV',16),
('2026-07-23','12:30 AM','ATX','SEA','Q2 Stadium, Austin, TX','Apple TV',16),
('2026-07-23','12:30 AM','HOU','DC','Shell Energy Stadium, Houston, TX','Apple TV',16),
('2026-07-23','12:30 AM','SKC','MIN','Sporting Park, Kansas City, KS','Apple TV',16),
('2026-07-23','12:30 AM','NSH','MTL','Geodis Park, Nashville, TN','Apple TV',16),
('2026-07-23','1:30 AM','COL','SAN','Dicks Sporting Goods Park, Commerce City, CO','Apple TV',16),
('2026-07-23','2:30 AM','LA','STL','Dignity Health Sports Park, Carson, CA','Apple TV',16),
('2026-07-23','2:30 AM','LAFC','RSL','BMO Stadium, Los Angeles, CA','Apple TV',16),
('2026-07-23','2:30 AM','POR','DAL','Providence Park, Portland, OR','Apple TV',16),
('2026-07-23','2:30 AM','SJ','ORL','PayPal Park, San Jose, CA','Apple TV',16)
on conflict do nothing;

-- ============================================================
-- SEED: CURRENT STANDINGS (July 20, 2026)
-- ============================================================
insert into mls_standings (team_code, games_played, wins, losses, draws, goals_for, goals_against, home_record, away_record) values
('NSH',15,11,1,3,32,11,'7-0-1','4-1-2'),
('MIA',15,9,2,4,39,28,'2-1-3','7-1-1'),
('CHI',14,8,4,2,27,16,'5-3-0','3-1-2'),
('NE',14,8,5,1,22,18,'7-1-0','1-4-1'),
('RBNY',15,6,5,4,25,32,'3-2-2','3-3-2'),
('CLT',15,6,6,3,24,23,'5-2-2','1-4-1'),
('CIN',15,5,5,5,36,37,'4-2-1','1-3-4'),
('NYC',15,5,6,4,25,21,'3-3-2','2-3-2'),
('DC',15,4,5,6,21,25,'2-3-2','2-2-4'),
('CLB',15,4,7,4,21,23,'3-2-2','1-5-2'),
('MTL',15,4,8,3,22,31,'3-2-2','1-6-1'),
('TOR',15,3,6,6,22,29,'2-2-5','1-4-1'),
('VAN',14,10,2,2,34,12,'7-1-0','3-1-2'),
('SJ',15,10,3,2,34,15,'4-2-1','6-1-1'),
('LAFC',16,8,5,3,27,17,'5-2-1','3-3-2'),
('RSL',14,8,4,2,26,19,'7-1-0','1-3-2'),
('DAL',15,7,4,4,30,22,'3-2-4','4-2-0'),
('HOU',14,7,4,3,18,16,'4-1-2','3-3-1'),
('COL',15,5,7,3,22,28,'3-3-2','2-4-1'),
('LA',15,4,7,4,18,24,'3-2-2','1-5-2'),
('ATX',15,4,7,4,18,26,'3-2-2','1-5-2'),
('SAN',15,4,8,3,21,29,'3-3-2','1-5-1'),
('POR',15,3,8,4,16,27,'2-3-2','1-5-2'),
('STL',15,2,9,4,14,28,'1-5-2','1-4-2'),
('SKC',15,1,9,5,12,31,'0-5-2','1-4-3'),
('MIN',14,6,3,5,19,17,'4-1-2','2-2-3'),
('SEA',14,6,3,5,17,15,'4-1-2','2-2-3'),
('ATL',14,4,7,3,14,22,'3-2-2','1-5-1'),
('ORL',14,3,9,2,14,28,'2-4-1','1-5-1'),
('PHI',14,3,8,3,14,22,'2-4-1','1-4-2')
on conflict (team_code, season) do nothing;

-- ============================================================
-- VIEWS
-- ============================================================
create or replace view mls_eastern_standings as
select t.team_name, s.games_played, s.wins, s.losses, s.draws,
       s.points, s.goals_for, s.goals_against, s.goal_differential,
       s.home_record, s.away_record
from mls_standings s
join mls_teams t on s.team_code = t.team_code
where t.conference = 'Eastern'
order by s.points desc, s.goal_differential desc;

create or replace view mls_western_standings as
select t.team_name, s.games_played, s.wins, s.losses, s.draws,
       s.points, s.goals_for, s.goals_against, s.goal_differential,
       s.home_record, s.away_record
from mls_standings s
join mls_teams t on s.team_code = t.team_code
where t.conference = 'Western'
order by s.points desc, s.goal_differential desc;

create or replace view mls_july22_slate as
select f.game_date, f.kickoff_time_ct,
       ht.team_name as home_team, at2.team_name as away_team,
       f.venue, f.tv_network,
       o.home_ml, o.away_ml, o.draw_ml, o.total_goals
from mls_fixtures f
join mls_teams ht on f.home_team = ht.team_code
join mls_teams at2 on f.away_team = at2.team_code
left join mls_odds o on o.fixture_id = f.id
where f.game_date = '2026-07-22'
order by f.kickoff_time_ct;

create or replace view mls_todays_picks as
select p.pick_date, ht.team_name as home, at2.team_name as away,
       p.pick_type, p.pick_side, p.pick_line, p.confidence, p.edge,
       p.units, p.published, p.result
from mls_picks p
join mls_fixtures f on p.fixture_id = f.id
join mls_teams ht on f.home_team = ht.team_code
join mls_teams at2 on f.away_team = at2.team_code
where p.pick_date = current_date
order by p.confidence desc;

-- ============================================================
-- END | 9 tables | 4 views | 30 teams | 15 fixtures seeded
-- Next: INSERT into mls_odds after pulling live lines July 22
-- ============================================================
