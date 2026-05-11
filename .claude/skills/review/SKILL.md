---
name: review
description: Read recent data and produce analysis. Weekly review (last 7 days adherence + weight trend + ONE change for next week). Monthly review (4-week trend + body comp progress + supplement adherence). Quarterly review (biomarker progression + goal alignment + protocol adjustment). Annual (year-in-review). Biomarker-event review (after a new bloodwork ingest, generated automatically by ingest, but can be re-run). Correlation review (symptoms vs food, sleep vs eating, mood vs sleep, recovery vs lifting). Lint (find contradictions across pages, stale claims, orphan pages, missing cross-references, gaps). Risk projection (where biomarkers are headed if current pace continues; e.g., "HbA1c will hit 6.0 by November"). Pattern dashboards (weight + kcal + protein + sleep + RHR over 30/90 days as a chart). Invoke when the user says "weekly review", "how am I doing", "review my week", "monthly review", "quarterly", "year in review", "am I on track", "what's my trend", "show me a chart", "where am I headed", "what does my data say", "check my data", "lint", "/review", or after an ingest of bloodwork (auto-chains to biomarker-event review).
---

# Review skill

Read data, produce analysis. Always cite the wiki pages your analysis comes from.

## Pre-flight

If `wiki/profile/identity.md` is empty, redirect: "We don't have a baseline yet. Want to onboard first?" then invoke `checkin` (onboarding).

## Sub-flows

### Weekly review

1. Read last 7 daily logs from `wiki/logs/YYYY/MM/`.
2. Compute:
   - kcal hit %, protein hit %, fiber hit % (vs `wiki/targets/current.md`)
   - Days with no log (missed days)
   - Weight 7-day moving average + trend (↓/→/↑)
   - Workouts done vs planned
   - Sleep average
   - Symptoms recurring this week
3. Identify wins (best day, easiest meal, biggest improvement).
4. Identify friction (worst day, where adherence broke, recurring failure mode).
5. Propose ONE change for next week (one only, per adherence principle).
6. Save as `wiki/reviews/weekly/YYYY-WXX.md`.
7. Refresh `hot.md`.
8. Append `## [DATE TIME] review | weekly YYYY-WXX` to `log.md`.

### Monthly review

Same as weekly but for last 4 weeks. Add:
- Body comp delta (waist, weight, photo if available)
- Supplement adherence rate
- Lab results if any happened this month
- Strategic adjustment (multiple changes are OK at monthly cadence)

Save as `wiki/reviews/monthly/YYYY-MM.md`.
Append `## [DATE TIME] review | monthly YYYY-MM` to `log.md`.

### Quarterly review

Same as monthly but for last 12 weeks. Add:
- Biomarker progression (read all ingested bloodwork over the quarter)
- Goal alignment check
- Protocol adjustment proposal
- Big-picture narrative

Save as `wiki/reviews/quarterly/YYYY-Q?.md`.
Append `## [DATE TIME] review | quarterly YYYY-Q?` to `log.md`.

### Annual review

Same as quarterly but for last 12 months. Add:
- Year-in-review story (what changed, what didn't, what we learned)
- Goal reset proposal for next year
- Workout periodization for next year
- Consider revising CLAUDE.md operating defaults if anything materially shifted (rare)

Save as `wiki/reviews/annual/YYYY.md`.
Append `## [DATE TIME] review | annual YYYY` to `log.md`.

### Biomarker event review

(Usually generated automatically by `ingest` skill on bloodwork ingest. Re-run if user wants a fresh re-analysis or didn't get the auto-version.)

For a specific bloodwork date:
1. Compare to previous reading (numeric diff per marker).
2. Flag abnormals against India thresholds.
3. Connect to recent diet/lifestyle changes if visible in logs (e.g., "switched to mustard oil 6 weeks ago, LDL dropped 15 points").
4. Propose plan adjustments (specific: "raise fiber target from 35 to 40g for next 12 weeks").
5. Recommend physician follow-up if needed.

Save as `wiki/reviews/biomarker-events/YYYY-MM-DD-<labname>.md`.
Append `## [DATE TIME] biomarker-event | <summary>` to `log.md`.

### Correlation review

Find patterns across symptoms + food + sleep + mood + recovery over time.

1. Read daily logs over the last 30/60/90 days (let user pick window or default to 60).
2. Look for:
   - Symptoms that recur after specific foods (gluten, dairy, high-carb meals, specific spices like Saoji)
   - Energy crashes correlated with meal timing or composition (post-rice 3pm crash)
   - Mood dips correlated with sleep deprivation (Oura readiness <70 + low energy)
   - Workout PR days correlated with rest/sleep/food the day before
   - Bloating correlated with specific dals or vegetables
   - Sleep quality vs alcohol/caffeine timing
3. Save findings as `wiki/reviews/correlations/YYYY-MM-DD-<topic>.md`.
4. Surface the most actionable insight to the user.
5. Append `## [DATE TIME] review | correlations: <topic>` to `log.md`.

### Lint

1. Walk all wiki pages.
2. Find:
   - Contradictions: two pages claiming different facts about the same thing (e.g., target weight in goals.md vs targets/current.md)
   - Stale claims: data superseded by newer entries (old weight in profile vs latest in anthropometry)
   - Orphan pages: no inbound links from anywhere
   - Missing cross-references: pages that should link to each other (food-library entry referencing a nonexistent knowledge page)
   - Gaps: recurring questions in chat history (or recurring symptoms in logs) that lack a dedicated page
3. Report findings to the user. Offer to fix each one.
4. Save report as `wiki/reviews/lint-YYYY-MM-DD.md`.
5. Append `## [DATE TIME] lint | <N findings>` to `log.md`.

### Risk projection

User: "where is my HbA1c headed" / "what's my trajectory" / "if I keep going like this"

1. Read the relevant biomarker series.
2. Fit a simple linear trend (or piecewise if there's a clear regime change).
3. Project to 3 months / 6 months / 12 months.
4. Flag if projection crosses any India threshold (HbA1c 5.7 → prediabetic, LDL 100 → at-risk, etc.).
5. State clearly: "this is a linear projection assuming current pace continues. Behavior change can bend the curve."
6. Save as `wiki/reviews/projections/YYYY-MM-DD-<biomarker>.md`.
7. Append `## [DATE TIME] review | projection: <biomarker>` to `log.md`.

### Pattern dashboard (chart)

User: "show me a chart" / "dashboard" / "visualize my X"

1. Read relevant series (weight, kcal, protein, sleep, RHR, HRV, etc.) over user-chosen window.
2. Generate matplotlib chart via Bash (small Python script). Save PNG to `wiki/reviews/charts/YYYY-MM-DD-<topic>.png`.
3. Embed in a markdown wrapper page that explains what's shown.
4. Append `## [DATE TIME] review | chart: <topic>` to `log.md`.

## Bookkeeping (always)

After every review:
1. Append to `log.md` with right `kind`.
2. Update `index.md` with new review page.
3. Refresh `hot.md` with the key insight from this review.
