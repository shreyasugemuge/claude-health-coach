---
name: help
description: Print a navigable, user-facing overview of this health coach project. Lists all skills with example phrases, where files live, where to drop things, common things to say, and stale-section reminders. Invoke when the user says "help", "what can you do", "what skills do you have", "show me commands", "I'm new", "where do I start", "what's available", "how does this work", "/health:help", "guide", or "tour". (Note: built-in `/help` is reserved by Claude Code; the project's namespaced shortcut is `/health:help`. Natural-language "help" routes here via this description.) This is the project's table of contents for humans.
---

# Help skill

When invoked, print a navigable overview to the user. Always read the latest state from `index.md` and `hot.md` before printing so the help reflects current reality.

## What to do

1. Read `.claude/skills/*/SKILL.md` to enumerate the current skill list (in case it has grown).
2. Read `index.md` to summarize what's already in the wiki.
3. Read `hot.md` to know current state and recent activity.
4. Print the help in the structure below.
5. Append to `log.md`: `## [DATE TIME] note | help shown`.

## Output structure

Print this as markdown to the user. Adapt phrasing to current state (e.g., if onboarded, mention current weight/goal; if not, lead with "let's get you set up").

```
# Your health coach

A personal, India-specific health, nutrition, and fitness coach built on the LLM Wiki pattern. Everything is local on your machine.

## How to use it

You don't need to remember commands. Just talk naturally. The coach matches your message to a skill automatically.

## Common things you can say

**Logging (just say what happened)**
- "had 2 phulkas and dal for lunch"
- "weighed 78.4 this morning"
- "did 3x8 squats at 60kg, 3x10 bench at 40kg"
- "headache since lunch"
- "had 4 chais today"
- "took my B12"

**Photos (just drop them)**
- Food photo in chat → I identify and log with a confidence band
- Body comp photo to `raw/photos/body/` → filed under monthly tracking
- Bloodwork PDF to `raw/bloodwork/` → parsed, biomarkers updated

**Planning**
- "plan dinner"
- "plan tomorrow"
- "plan the week"
- "want McSpicy Paneer Wrap tonight"
- "what can I order at the Saoji place"
- "brief the cook for tomorrow"
- "decode this menu" (with photo)

**Events / calendar**
- "wedding Saturday"
- "traveling to Mumbai 15-18"
- "vrat tomorrow"
- "Ekadashi this weekend"

**Reviews / analysis**
- "weekly review" or "how was my week"
- "monthly review"
- "quarterly review"
- "am I on track"
- "where is my HbA1c headed"
- "show me a chart"

**Updates**
- "let's start" or "first time" → onboarding (auto-runs if profile is empty)
- "checkin" → auto-detects whether weekly/monthly/quarterly is due
- "let me update preferences"
- "let me update inventory"
- "let me update my supplements"

## Skills (auto-trigger from natural language)

- **help** (this skill) - "help", "what can you do"
- **checkin** - onboarding + periodic interviews. "let's start", "weekly review", "let me update X"
- **log** - record meals, weight, body, workouts, symptoms, beverages, supplements. "had X", "weighed X", drop a photo
- **plan** - meal/cook/workout/event suggestions. "plan dinner", "want X tonight", "brief the cook", "wedding Saturday"
- **ingest** - process files in raw/. drop a bloodwork PDF, "I dropped my Oura export"
- **review** - weekly/monthly/quarterly/annual analysis. "how am I doing", "show me a trend"

## Slash command shortcuts (namespaced under `health:`)

- `/health:help` - this skill
- `/health:checkin [weekly|monthly|quarterly|annual|onboarding|<section>]`
- `/health:log <what happened>`
- `/health:plan <dinner|day|week|cook|decode <restaurant>|event|workout|fit <food>>`
- `/health:ingest [path | inbox]`
- `/health:review [weekly|monthly|quarterly|annual|lint|correlations <topic>|projection <biomarker>|chart <topic>]`

Why namespaced: built-in Claude Code commands like `/help` and `/review` are reserved. The `health:` prefix avoids collision and groups all project commands together.

## Where things live

- **CLAUDE.md** the schema (auto-loaded each session)
- **hot.md** rolling 14-day cache (read first)
- **index.md** wiki catalog
- **log.md** append-only event log

- **wiki/profile/** you, your goals, preferences, kitchen, supplements, psychology
- **wiki/biomarkers/** lab values, sleep/recovery, body composition over time
- **wiki/targets/** current macros for the week
- **wiki/plans/** current week's meals + workouts + cook briefs
- **wiki/calendar/** festivals, personal events, vrat, wedding season
- **wiki/food-library/** dishes you eat (auto-grows from logs)
- **wiki/logs/YYYY/MM/DD.md** daily logs
- **wiki/reviews/** weekly, monthly, quarterly, annual, biomarker events, correlations
- **wiki/knowledge/** India-specific reference (P1+)

## Where to drop things

- Bloodwork PDFs → `raw/bloodwork/`
- Doctor notes / prescriptions → `raw/medical/`
- Food photos → paste in chat, OR `raw/photos/`
- Body comp photos → `raw/photos/body/`
- Apple Health / Oura / Apple Watch exports → `raw/wearable-exports/`
- Grocery receipts (Zepto/BigBasket/Blinkit) → `raw/grocery-receipts/`
- Random notes you haven't sorted → `raw/inbox/` (I'll triage)

## What I watch (and remind you about)

- Weight: every 14 days
- Body comp photos + tape: every 30 days
- Bloodwork: every 180 days
- Weekly checkin: every 14 days
- Monthly checkin: every 35 days
- Quarterly checkin: every 100 days
- Inventory: every 30 days

I'll mention these gently when they go stale; I won't auto-run anything without you saying so.

## India-specific defaults

This coach uses Asian-Indian thresholds (BMI ≥23 overweight, waist M≥90/F≥80), LAI 2024 LDL targets, ICMR DGI 2024 caps (salt 5g, oil 25-30g, sugar 20-25g), IFCT 2017 macros. It accounts for vrat days, chai accounting, wedding season, AQI, family medical clusters, and the cook-coordination reality.

## Privacy + medical safety

Everything is local on your machine. Do not push this folder to a public git remote.

I am not a doctor. I surface signals against established thresholds. For anything genuinely abnormal, see a physician. I do not prescribe.

## Current state

[Print 1-2 sentences summarizing what's in hot.md: phase, whether onboarded, latest weight if known, anything stale.]
```

## Bookkeeping

After every help invocation:
- Append to `log.md`: `## [DATE TIME] note | help shown`.
- Do NOT touch index.md or hot.md (help is read-only).
