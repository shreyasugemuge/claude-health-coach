---
description: Run a structured interview (auto-detects cadence, or accepts a mode hint)
argument-hint: [weekly|monthly|quarterly|annual|onboarding|<section>]
---

Invoke the `checkin` skill. If $ARGUMENTS is provided, use it as the mode hint (e.g., `weekly`, `monthly`, `preferences`). Otherwise auto-detect the most overdue mode from `log.md` cadence.
