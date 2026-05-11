---
description: Suggest meals, workouts, cook briefs, menu decodes, or event pre-mortems
argument-hint: <dinner|day|week|cook|decode <restaurant>|event <name dates>|workout|fit <food>>
---

Invoke the `plan` skill. $ARGUMENTS scopes the request:
- `dinner` / `lunch` / `breakfast` for a single meal
- `day` / `tomorrow` / `week` for full plans
- `cook` to brief the household cook
- `decode <restaurant>` to decode a menu against today's macros
- `event <name dates>` to pre-mortem (wedding, travel, vrat, festival)
- `workout` for recovery-aware workout intensity
- `fit <food>` for the McDonald's wrap protocol (compute fit + suggest moves)

If empty, ask the user what they want to plan.
