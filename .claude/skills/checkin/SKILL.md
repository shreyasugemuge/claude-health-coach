---
name: checkin
description: Periodic structured interview to keep the wiki current. Modes: onboarding (first session, ~30 min, AUTO-RUNS when wiki/profile/identity.md is empty), weekly (5 min, every 7 days), monthly (15 min, body comp + supplements + preferences), quarterly (30 min, lifestyle + goals + bloodwork prompt), annual (60 min, year-in-review), and ad-hoc (refresh a specific section). Invoke when the user says "checkin", "let's start", "first time", "set me up", "let's onboard", "weekly review", "let me update X", "weighed myself" (then chain to log), "haven't checked in", "let's catch up", "monthly review", "quarterly review", "year in review", "tell me what's missing", or when CLAUDE.md detects a stale wiki section. If wiki/profile/identity.md is empty or missing, auto-run onboarding mode after a one-line "let's set you up" intro.
---

# Checkin skill

Periodic interview to keep the wiki current. Six modes: onboarding, weekly, monthly, quarterly, annual, ad-hoc.

## Mode auto-detection

If invoked without a specified mode, decide from the file system + `log.md`:

- `wiki/profile/identity.md` empty → onboarding (auto, no need to ask).
- Last `checkin | weekly` >7 days ago → suggest weekly.
- Last `checkin | monthly` >30 days ago → suggest monthly.
- Last `checkin | quarterly` >90 days ago → suggest quarterly.
- Last `checkin | annual` >365 days ago → suggest annual.

When in doubt, ask: "Last weekly was X days ago, last monthly Y. Want to do [recommended], or pick a different mode?"

## Modes

### Onboarding (~30 min, first time only)

Before starting, say one line: "Let's set you up. About 30 minutes, six quick rounds. Ready?" If yes, proceed.

Then run six batched rounds. ONE round per message. Wait for answers between rounds. Save into `wiki/profile/*.md` as you go.

**Round 1: Identity**
Ask in one message:
- Name and what to call you
- Age, sex
- Height, current weight
- City
- Daily routine (desk job? travel? shift work? field work?)

Save → `wiki/profile/identity.md`, append first weight to `wiki/profile/anthropometry.md`.

**Round 2: Medical**
Ask in one message:
- Diagnosed conditions (diabetes, BP, thyroid, fatty liver, PCOS, IBS, cholesterol, anything else)
- Medications and supplements (name, dose, timing)
- Allergies / intolerances
- Family medical history (T2DM, CVD, cancer, obesity in parents/siblings)
- Date of last bloodwork. If recent and they have it, ask them to drop the PDF in `raw/bloodwork/` now.

Save → `wiki/profile/medical.md`, `wiki/profile/supplements.md`. If they share bloodwork, invoke `ingest` skill before continuing to Round 3.

**Round 3: Goals**
Ask in one message:
- What feels broken right now (energy, weight, lab numbers, specific symptom, mood)
- What does winning look like in 3 months
- What does winning look like in 12 months
- What have you tried before, why didn't it stick

Save → `wiki/profile/goals.md`. Use the failure modes to inform target-setting (e.g., "couldn't stick to 1500 kcal" → use deficit ≤400 kcal/day).

**Round 4: Preferences**
Ask in one message:
- Top 5 favorite foods (be specific: "paneer butter masala", not "paneer")
- Top 5 hated foods (so I never suggest them)
- Off-limits (vegetarian, vegan, eggless, religious, allergic)
- Comfort foods that NEED to fit (the wraps, biryanis, sweets you'll eat anyway)
- Best and worst restaurants you'd order from

Save → `wiki/profile/preferences.md`.

**Round 5: Kitchen**
Ask in one message:
- Who cooks at home (you, family, dedicated cook, mostly outside)
- Weekly meal rotation: typical Mon-Sun breakfast/lunch/dinner
- Cooking oils used (mustard, sunflower, ghee, groundnut, refined)
- Pantry staples (jowar, bajra, rice, dals, milk, curd, paneer, eggs)
- Eating-out frequency per week, what kind of places
- If a cook is involved, what's her existing routine and capacity for change

Save → `wiki/profile/kitchen.md`, `wiki/profile/kitchen-cook.md` (if applicable), `wiki/profile/inventory.md`.

**Round 6: Constraints + Workout + Lifestyle**
Ask in one message:
- Cooking time available on weekdays
- Budget concerns
- Workout setup: gym available (when, how often), home equipment, outdoor walking access
- Current activity level (sedentary, lightly active, moderately active, very active)
- Sleep schedule (typical bed/wake times, quality)
- Stress level 1-10 and main stressors
- Caffeine pattern (cups/day) and alcohol pattern
- Wearables to ingest from: iPhone Apple Health, Apple Watch, Oura - which one's data do you trust most?

Save → `wiki/profile/constraints.md`, `wiki/profile/lifestyle.md`.

**After all 6 rounds, you compute and write:**
1. BMR via Mifflin-St Jeor.
2. TDEE = BMR × activity multiplier.
3. Calorie target. If weight loss is the goal, deficit ≤400 kcal/day for first 8 weeks. If maintenance/lab-fix, hold at TDEE.
4. Protein at 1.6 g/kg.
5. Fiber 35 to 40 g/day.
6. ICMR caps (salt ≤5g, oil 25-30g, sugar 20-25g).
7. Asian-Indian risk overlay if relevant.
8. Write `wiki/targets/current.md` with all the above + reasoning.
9. Write `wiki/targets/protocol.md` (current dieting approach, why this protocol).
10. Generate `wiki/plans/current-week-meals.md` (7-day plan respecting kitchen rotation, with one favorite/splurge baked in).
11. Generate `wiki/plans/current-week-workouts.md` (gym schedule + walks, recovery-aware).
12. Show the plan, take feedback, adjust, then prompt "ready to start logging? Just tell me what you eat or drop a photo."

If user shared bloodwork in Round 2, the ingest skill ran and updated biomarkers. Use those results in target-setting.

Bookkeeping:
- Append `## [DATE TIME] onboard | initial onboarding complete` to `log.md`.
- Update `index.md` with all new pages.
- Refresh `hot.md` with the new state.

### Weekly (~5 min)

**Quick numbers:**
- Weight (morning, fasted, today's reading or this week's lowest stable)
- Sleep this week (avg hours, Oura readiness if available)
- Workouts done (list)
- Anything painful or symptomatic worth noting

**Adherence:**
- 1-10: how was the week
- One win
- One friction point
- Anything you need from me next week

**You then:**
- Append weight to `wiki/profile/anthropometry.md`. Update 7-day moving average.
- Generate `wiki/reviews/weekly/YYYY-WXX.md` (adherence stats from logs, weight trend, wins, friction, ONE proposed change for next week).
- Update `hot.md`.
- Append `## [DATE TIME] checkin | weekly` to `log.md`.

Adjust `wiki/targets/current.md` ONLY if data demands it. One change per week max.

### Monthly (~15 min, target 1st of month)

Weekly content PLUS:

**Body composition:**
- Waist tape: 3 measurements (umbilical, narrowest, widest) → record narrowest
- Hip tape
- Optional: thigh, neck, arm
- Front + side photo (same lighting, same time of day, same clothing) → drop into `raw/photos/body/YYYY-MM-front.jpg` and `YYYY-MM-side.jpg`

**Preferences refresh:**
- Any new foods you fell in love with this month
- Any foods you got tired of
- New restaurants worth adding to food-library

**Inventory + supplements:**
- What's currently in pantry/fridge
- What ran out, restock list
- Are you taking the supplements we agreed
- Side effects, brand changes

**You then:**
- Update `wiki/biomarkers/body-composition.md` (timestamped row).
- Update `wiki/profile/preferences.md`, `inventory.md`, `supplements.md`.
- Generate `wiki/reviews/monthly/YYYY-MM.md` (4-week trend, body comp progress, supplement adherence, ONE strategic adjustment).
- Refresh `hot.md`.
- Append `## [DATE TIME] checkin | monthly` to `log.md`.

### Quarterly (~30 min)

Monthly content PLUS:

**Bloodwork:**
- When was last bloodwork
- If 6+ months ago, recommend a panel (lipid + HbA1c + LFT + B12 + Vit D + thyroid + CBC + creatinine)
- If user has fresh bloodwork in `raw/bloodwork/`, invoke `ingest` skill now

**Lifestyle:**
- Job/hours/travel pattern shifts
- Sleep schedule shifts
- Stress level (1-10) and main stressors
- Caffeine/alcohol pattern shifts
- Workout setup changes

**Goals:**
- Are we still aiming at the right thing
- Have priorities shifted (energy vs weight vs labs vs aesthetics)
- Anything new you want to fix

**Medical:**
- New diagnoses
- New meds or supplement changes
- Family medical updates

**You then:**
- Update `wiki/profile/lifestyle.md`, `goals.md`, `medical.md`.
- If bloodwork ingested: `wiki/reviews/biomarker-events/YYYY-MM-DD.md` already created by ingest.
- Possibly trigger `wiki/targets/current.md` revision (multiple changes are OK at quarterly).
- Generate `wiki/reviews/quarterly/YYYY-Q?.md`.
- Refresh `hot.md`.
- Append `## [DATE TIME] checkin | quarterly` to `log.md`.

### Annual (~60 min, target birthday or January)

Quarterly content PLUS:
- Year-in-review: weight trend over 12 mo, biomarker trends, big wins, stuck points.
- Goal reset for next year.
- Workout periodization for next year.
- Bloodwork: definitely repeat the full panel.
- Coach effectiveness review: what's working about how we work together, what isn't.

**You then:**
- Generate `wiki/reviews/annual/YYYY.md`.
- Optionally revise `CLAUDE.md` operating defaults if anything materially changed (rare).
- Reset target trajectory.
- Append `## [DATE TIME] checkin | annual` to `log.md`.

### Ad-hoc (variable)

User says "let me update <section>". Ask only the questions for that section. Save. Done.

Common ad-hoc:
- "update preferences" → preferences refresh from monthly
- "update inventory" → kitchen + pantry
- "update meds" or "update supplements" → medical + supplements
- "update goals" → goals + targets
- "update kitchen rotation" → kitchen.md
- "update constraints" → constraints.md (e.g., job change, less time to cook)

Append `## [DATE TIME] checkin | ad-hoc <section>` to `log.md`.

## Stale-section reporting

When invoked without a specified mode, also report any stale sections (per CLAUDE.md table). Offer to refresh the most overdue one in addition to the cadenced checkin.

## Bookkeeping (always)

After ANY checkin mode completes:
1. Append to `log.md`: `## [DATE TIME] checkin | <mode> completed, <one-line summary>`.
2. Update `index.md` with any new pages.
3. Refresh `hot.md` (trim entries >14 days).
4. If targets changed: also append `## [DATE TIME] target-change | <reason>` to `log.md`.
