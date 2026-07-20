# Bodhi Bets — Daily Workflow Standard Operating Procedure
*This is the master process. Run this every day for every active league.*

---

## DAILY WORKFLOW — Step by Step

### STEP 1: MORNING AUDIT (by 6 AM CT)
- Check which leagues have games today
- Pull slate for each active league
- Flag any injury/scratch/lineup news
- Pull Polymarket odds + sportsbook lines

### STEP 2: RUN INTERNAL BRIEF (per league)
- Build Bodhi Double-Decker Model (Sportsbook Win% + Polymarket Win%)
- Calculate Bodhi Blend confidence score
- Identify top plays: ML / Spread / Total / Props / First Basket or First Goal
- Flag FADES (no edge, juice too high, model conflict)
- Assign confidence scores (only publish 70+)

### STEP 3: INTERNAL CONFIDENCE CHECK
- Review data before publishing anything
- Flag any model conflicts between Polymarket and sportsbooks
- Confirm starters / lineups locked
- Downgrade or remove any plays with new injury news

### STEP 4: BUILD SUBSCRIBER POST
- Strip internal data — subscribers see picks only
- Format: Lock / 2-Leg Parlay / 3-Leg Parlay / Props / Fades
- Subject line: BODHI BETS | [LEAGUE] PICKS — [Day Date, Year]
- Send to Gumroad GANGHA members
- Post to public Gumroad profile

### STEP 5: SAVE EVERYTHING
- ClickUp: 3 tasks in Daily Content Pipeline (Internal Brief / Subscriber Post / Verified Brief)
- GitHub: Push 3 files to bodhibets/bodhibets-website/docs/
  - docs/daily_blocks/YYYY-MM-DD-[league]-internal.md
  - docs/subscriber_posts/YYYY-MM-DD-[league]-post.md
  - docs/daily_blocks/YYYY-MM-DD-[league]-verified.md
- Google Drive: Update master daily file

### STEP 6: PRE-GAME UPDATE (90 min before first pitch/tip/kickoff)
- Re-check all confirmed starters
- Re-check line movement
- Re-check Polymarket for any big swings
- Flag any changes to subscriber base if needed

---

## LEAGUE TRACKER

| League | Status | First Covered | Notes |
|--------|--------|--------------|-------|
| MLB | ACTIVE | 7/20/2026 | 15-game slates, daily |
| WNBA | ACTIVE | 7/20/2026 | 4-12 games, check daily |
| MLS | BUILDING | Next: 7/22/2026 | Database schema in progress |
| NFL | PENDING | Aug 2026 preseason | |
| NBA | PENDING | Oct 2026 | |
| NHL | PENDING | Oct 2026 | |
| CFB | PENDING | Aug 2026 | |
| NCAAB | PENDING | Nov 2026 | |
| PGA | PENDING | TBD | |
| UFC/MMA | PENDING | TBD | |

---

## TOOLS USED DAILY
- Polymarket (market confidence)
- Sportsbook lines (sharp money)
- ClickUp (task management + save)
- GitHub (version control + file storage)
- Google Drive (master daily reference)
- Gumroad (subscriber delivery)
- Supabase (database — MLS and beyond)

---

## MODEL LOGIC (Bodhi Double-Decker)
- Sportsbook Win% = implied probability from moneyline
- Polymarket Win% = crowd/market confidence
- Bodhi Blend = weighted average (books 60% / Polymarket 40%)
- Edge = Bodhi Blend % minus implied odds %
- Publish threshold: Confidence 70+ AND Edge 2%+
- Flag conflicts: When books and Polymarket diverge by 15%+

---

*Last updated: July 20, 2026*
