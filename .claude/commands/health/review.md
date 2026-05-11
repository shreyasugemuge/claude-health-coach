---
description: Run an analysis (weekly/monthly/quarterly/annual/lint/correlations/projection/chart)
argument-hint: [weekly|monthly|quarterly|annual|lint|correlations <topic>|projection <biomarker>|chart <topic>]
---

Invoke the `review` skill. $ARGUMENTS specifies the type and optional topic:
- `weekly` / `monthly` / `quarterly` / `annual` for cadenced reviews
- `lint` to find contradictions, stale claims, orphans, gaps
- `correlations <topic>` to find patterns (e.g., `correlations sleep` or `correlations symptoms`)
- `projection <biomarker>` to project a trajectory (e.g., `projection HbA1c`)
- `chart <topic>` to generate a visual dashboard

If empty, default to the most overdue cadenced review per `log.md`.
