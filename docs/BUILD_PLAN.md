# BodhiBets Build Plan
_Last updated: 2026-07-21_

## What We're Building
A sports betting intelligence service that produces:
1. **Internal confidence briefs** — data-rich, private, pre-game analysis
2. **Subscriber posts** — clean, simple, high-conviction picks for paying subscribers
3. **Tracking layer** — Bitly link tracking + Supabase engagement logging

---

## System Architecture

```
[Odds APIs] → [Supabase DB] → [Confidence Brief] → [Subscriber Post] → [Bitly] → [Tracking]
      ↑                ↑               ↑                    ↑
  External feeds   GitHub migration  Internal tool        Published output
```

---

## Stack

| Layer | Tool | Status |
|-------|------|--------|
| Frontend | Next.js (bodhibets-website) | ✅ Repo exists |
| Database | Supabase (d20dc2bc2a4542bd3469cbb563eae84e) | ⏳ Migration ready to run |
| Schema migrations | `supabase/migrations/` | ✅ Pushed |
| Odds data | Manual seed → API (Phase 2) | ⏳ Pending |
| Link tracking | Bitly API | ⏳ Pending |
| Subscriber delivery | Substack / Discord | ⏳ Pending |
| Task management | ClickUp | ✅ Active |

---

## Phase 1 — Foundation (This Week)

### Step 1: Deploy Database ✅ READY
- [ ] Open Supabase SQL editor for project `d20dc2bc2a4542bd3469cbb563eae84e`
- [ ] Paste and run `supabase/migrations/20260721_001_mls_schema.sql`
- [ ] Verify all 8 tables + 3 views created
- [ ] Confirm RLS policies active

### Step 2: Seed MLS Teams
- [ ] Run teams seed file (30 MLS teams, both conferences)
- [ ] Run July 22 fixtures seed (15 games)
- [ ] Run current standings seed

### Step 3: Odds Pipeline (Manual first, API Phase 2)
- [ ] Create daily odds INSERT template
- [ ] Manually populate odds for next slate
- [ ] Verify `v_daily_slate` view returns correct data

### Step 4: Confidence Brief Workflow
- [ ] Pull `v_daily_slate` data
- [ ] Fill confidence brief template (internal)
- [ ] Save to `confidence_briefs` table

### Step 5: Subscriber Post Workflow
- [ ] Convert brief → subscriber post
- [ ] Generate Bitly short link
- [ ] Save to `subscriber_posts` + `link_tracking` tables
- [ ] Publish to platform

---

## Phase 2 — Automation
- Odds API integration (The Odds API or SportsDataIO)
- Auto-populate games + odds nightly
- Confidence score algorithm
- Automated Bitly link creation via API
- Dashboard: pick record, P/L tracker, subscriber growth

---

## Key Files

| File | Purpose |
|------|---------|
| `supabase/config.toml` | Supabase CLI project link |
| `supabase/migrations/20260721_001_mls_schema.sql` | Full MLS schema |
| `docs/BUILD_PLAN.md` | This file |
| `docs/CONFIDENCE_BRIEF_TEMPLATE.md` | Internal pick analysis template |
| `database/mls/mls-schema.sql` | Legacy schema reference |

---

## Tomorrow Morning Checklist
1. Open Supabase dashboard → SQL editor
2. Run migration file
3. Confirm tables exist
4. Seed teams + fixtures
5. Pull today's MLS odds
6. Fill confidence brief
7. Post picks

_That's the whole day. Stay on the checklist._
