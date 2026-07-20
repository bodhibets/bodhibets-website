# BODHI BETS — MLB Daily Workflow SOP

> Version 1.0 | Created: 2026-07-20 | Author: Bodhi Bets System
> This is the canonical, repeatable daily operating procedure for generating MLB picks, parlays, and daily block data.

---

## OVERVIEW

Every day is a **Block**. A block is a complete, self-contained unit of research, consensus, picks, and results for a given date and league. Once a block is saved, it is **never rebuilt** — it becomes the permanent historical record for that day.

---

## STEP 1 — SLATE INTAKE (by 9:00 AM CT)

- [ ] Pull today's full game schedule from MLB.com or ESPN
- [ ] Record: Date, Home Team, Away Team, First Pitch Time (CT), Venue, TV
- [ ] Note any doubleheaders, makeup games, or weather advisories
- [ ] Record probable pitchers for each game (from Baseball Savant or MLB.com)
- [ ] Flag games with missing/unconfirmed starters
- [ ] Insert all games as rows in `events` table with status = 'scheduled'

**Output:** Populated `events` table for today's date

---

## STEP 2 — MARKET SCAN (by 10:00 AM CT)

- [ ] For each game, check moneyline, run line (-1.5), and game total (O/U)
- [ ] Record opening lines and current lines (note movement)
- [ ] Flag any significant line movement (>10 cents ML, >0.5 total)
- [ ] Check for injury reports that may explain movement
- [ ] Check weather forecast for outdoor venues (wind speed/direction, precip)
- [ ] Identify NRFI/YRFI market availability for each game
- [ ] Insert market data into `markets` table

**Output:** Populated `markets` table; line movement flags noted

---

## STEP 3 — EXTERNAL SIGNALS (by 11:00 AM CT)

### Polymarket Leaderboard Scan
- [ ] Pull top 10 traders by ROI from Polymarket MLB markets
- [ ] Check each trader's current position on today's games
- [ ] Record: Trader ID, Market, Side (Home/Away/Over/Under), Stake %, Entry price
- [ ] Calculate weighted consensus signal per game (weight by Trader Score)
- [ ] Flag "Holder" status — traders who are holding large positions into game time
- [ ] Insert all signals into `external_signals` table

### Sharp Money Indicators
- [ ] Check BetQL / DK Network for % of bets vs % of money divergence
- [ ] Flag any game where <40% of bets = >60% of money (sharp action indicator)
- [ ] Note steam moves (fast line movement with high volume)

**Output:** Populated `external_signals` table; sharp flags noted

---

## STEP 4 — INTERNAL MODEL (by 12:00 PM CT)

For each shortlisted game (top 6-8 by signal strength), run:

### Pitching Analysis
- [ ] Starter ERA, FIP, xFIP (last 30 days)
- [ ] K/9, BB/9, HR/9
- [ ] Recent form: last 3 starts (IP, ER, result)
- [ ] Opponent batting average vs same handedness
- [ ] Bullpen ERA and usage (fatigue check — days of rest, recent appearances)

### Offensive Analysis
- [ ] Team wRC+ (last 14 days)
- [ ] Runs scored per game (last 10 games)
- [ ] BABIP trends (regression candidates)
- [ ] H2H records between these teams (current season)

### Situational
- [ ] Home/Away splits (current season)
- [ ] Day game vs night game splits
- [ ] Division rivalry flags (motivation factor)
- [ ] Travel fatigue (games in last 3 days, time zones crossed)

### Score each game:
- Model Win Probability % (internal)
- Implied Probability from moneyline
- Edge % = Model% - Implied%
- Confidence Score (1-100, based on edge + signal convergence)

**Output:** Populated `internal_signals` table; confidence scores per game

---

## STEP 5 — CONSENSUS ALIGNMENT (by 1:00 PM CT)

For each game analyzed, create alignment matrix:

| Game | Market | Internal Side | External Side | Alignment | Confidence |
|------|---------|---------------|---------------|-----------|------------|
| CLE vs MIN | ML | CLE | CLE | ALIGNED | 82 |
| PHI vs LAD | ML | PHI | LAD | CONFLICT | 41 |

- [ ] Build alignment matrix for all shortlisted games
- [ ] **ALIGNED** = Internal and external agree → eligible for picks
- [ ] **CONFLICT** = Disagreement → downgrade confidence, flag for monitoring only
- [ ] **EXTERNAL ONLY** = No internal signal → do not play, note for tracking
- [ ] Insert into `consensus_views` table

**Filters for eligible picks:**
- Confidence Score ≥ 65
- Edge % ≥ 3%
- At least 2 of top-5 traders on same side
- Alignment = ALIGNED

---

## STEP 6 — PICK GENERATION (by 2:00 PM CT)

### Pick of the Day (Lock)
- Highest confidence score among eligible picks
- Must be ALIGNED, Edge ≥ 5%, Confidence ≥ 75
- Record: Game, Market, Side, Line, Confidence, Edge, Reasoning

### 2-Leg Parlay
- Pick #1 + Pick #2 by confidence score
- Check correlation: avoid same game legs
- Target: +250 to +350 combined odds

### 3-Leg Parlay
- Pick #1 + Pick #2 + Pick #3
- Mixed markets (ML + Total) preferred for lower correlation
- Target: +500 to +800 combined odds

### Mega Parlay (Best Play Per Game)
- Take the single best eligible play from EACH game on the slate
- Only include games with Confidence ≥ 60
- Target: +1500 to +3000 combined odds

**Output:** Populated `final_plays` table for today

---

## STEP 7 — BLOCK SAVE & PUBLISH (by 3:00 PM CT)

- [ ] Mark today's `daily_block` as LOCKED (no further edits after this point)
- [ ] Export Pick of the Day card for social/Gumroad distribution
- [ ] Post picks to scheduled distribution channels
- [ ] Log block metadata: date, game_count, picks_generated, top_confidence

---

## STEP 8 — RESULTS LOGGING (next morning, by 9:00 AM CT)

- [ ] Check all final scores from yesterday's block
- [ ] Update `play_results` table: result (WIN/LOSS/PUSH), actual_score, notes
- [ ] Update `traders` table: adjust Trader Score based on yesterday's accuracy
- [ ] Calculate yesterday's ROI
- [ ] Archive block with final_status = 'SETTLED'

---

## KEY RULES

1. **Never rebuild a block.** Once LOCKED, a block is permanent history.
2. **No play without consensus.** If internal and external conflict, do not play.
3. **Confidence gates everything.** Nothing below 65 enters the pick pool.
4. **Parlays must be low-correlation.** No same-game legs. No same-team legs in 3+.
5. **Results always logged.** Every pick gets a result, even if not placed.
6. **Trader Scores are live.** Update after every settled block.

---

## LEAGUES COVERED (expand as ready)

- [x] MLB (primary)
- [ ] NFL (activate Week 1, 2026)
- [ ] NBA (activate October 2026)
- [ ] NHL (activate October 2026)
- [ ] Polymarket (politics, markets — always active)

---

## FILES & SYSTEM MAP

| File | Location | Purpose |
|------|----------|---------|
| `daily_mlb_workflow.md` | `docs/` | This SOP |
| `schema.sql` | `docs/` | Supabase table definitions |
| `daily_blocks/YYYY-MM-DD.md` | `docs/daily_blocks/` | Each day's block report |
| `play_log.csv` | `docs/` | All-time pick results log |

---

*Bodhi Bets — Built different. Research-first. Always.*
