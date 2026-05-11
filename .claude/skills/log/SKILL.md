---
name: log
description: Record anything that happens. Meals (text or photo), weight, body measurements (waist/hip/thigh/neck/arm), workouts (sets/reps/weight/duration/RPE), symptoms (headache, gut issues, energy crash, mood, skin, sleep quality), beverages (chai, coffee, water, alcohol), supplements taken or skipped. Invoke when the user says "had X", "ate X", "for breakfast/lunch/dinner I had", "weighed X", "weight is X", "did X workout", "feeling Y", "headache", "tired", "energy crashed", "had 3 chais", "had 2 cups coffee", "took my B12", "skipped omega-3", "log this", "log X", "/log X", drops a food photo, drops a body composition photo, or otherwise reports something to record. Updates today's wiki/logs/YYYY/MM/DD.md, grows wiki/food-library/ when a new food appears, and returns remaining macros for the day after meal logs.
---

# Log skill

Record any user event into the right wiki location.

## Pre-flight

If today's daily log file `wiki/logs/YYYY/MM/DD.md` does not exist, create it from the template in CLAUDE.md.

Compute today's date in IST (Asia/Kolkata).

If `wiki/profile/identity.md` is empty, the user is not onboarded. Run `checkin` first (onboarding mode) before any log.

## Sub-flows

### Meal log (text)

User: "had 2 phulkas, dal, bhindi, 1 cup curd"

1. Parse items + portions.
2. Look up macros in this order:
   a. `wiki/food-library/home/<dish>.md` (your stored portion-aware entry, if exists)
   b. IFCT 2017 (decompose composite dishes into raw ingredients)
   c. INDB recipes for cooked dishes
   d. Restaurant official PDF for branded items (link in food-library entry)
3. Compute kcal + P/C/F + fiber + sodium estimate.
4. Append to today's log under appropriate meal section. Infer slot from current time IST or user statement.
5. Update Daily Totals.
6. If a new dish appeared (not in food-library), create or extend `wiki/food-library/home/<slug>.md` with: macros, typical portion, source citation, when first seen.
7. Return: "Logged. ~XXX kcal, Yg protein. Remaining today: ZZZ kcal, Wg protein."
8. Append to `log.md`: `## [DATE TIME] meal-log | <slot>: <summary>, ~XXX kcal`.

### Meal log (photo)

User drops a photo (in chat or to `raw/photos/`).

1. Identify dishes from the image. Be specific (not "rice" but "looks like jeera rice or basmati, ~1.5 cups").
2. Estimate portions. Look for plate diameter, bowl size, hand if visible.
3. Ask ONE calibration question only:
   - Best: "Can you tell me the weight in grams of [item]?" if a kitchen scale is plausible.
   - Else: "Plate looks ~25cm. Was the dal a half-cup or full cup?"
4. After user answers, compute macros with explicit confidence band.
5. Save photo to `raw/photos/YYYY-MM-DD-HHMM-<slot>.jpg` if not already there.
6. Append to log with confidence: "logged ~480 kcal (range 380 to 580), 18g P, photo at raw/photos/..."
7. On the first photo of any session, remind: "Single-meal photos are ±35 to 40% on calories; trends matter more than precision."
8. Append to `log.md`: `## [DATE TIME] meal-log | <slot> from photo: ~XXX kcal (range YY-ZZ)`.

### Weight log

User: "weighed 78.4 this morning" or "weight is 78.4"

1. Append timestamped row to `wiki/profile/anthropometry.md` body table.
2. Also append `[date, kg, note]` tuple to the `weight_log` array in that file's YAML frontmatter (per Frontmatter contract in CLAUDE.md). Body table and frontmatter must stay in lockstep.
3. Recompute 7-day moving average.
4. Compare to last week's MA, flag direction (down / flat / up) vs goal.
5. Update `hot.md` with current weight + MA.
6. Append to `log.md`: `## [DATE TIME] weigh | 78.4 kg, 7d MA: X.X (↓/→/↑)`.
7. Return: "Logged. 7-day MA is X.X kg, trending [↓/→/↑] vs last week."

### Body measurements

User: "waist 92cm, hip 102cm" or drops a body comp photo to `raw/photos/body/`

1. Append timestamped row to `wiki/biomarkers/body-composition.md`.
2. If tape measurements are provided, also append `[date, waist_cm, hip_cm, whr]` tuple to the `waist_log` array in `wiki/profile/anthropometry.md` frontmatter (per Frontmatter contract).
3. If photo: file as `raw/photos/body/YYYY-MM-{front,side,back}.jpg`; reference in body-composition.md.
4. If both tape + photo provided, store together in same row.
5. Append to `log.md`: `## [DATE TIME] body-comp | waist X, hip Y, photo Z`.

### Workout log

User: "did 3x8 squats at 60kg, 3x10 bench at 40kg, 3x12 rows at 30kg" or "walked 5km in 50 min" or "30 min Surya Namaskar"

1. Append to today's log under Movement section.
2. If resistance training: log to `wiki/plans/current-week-workouts.md` (or to a dedicated workout log if user prefers detailed PR tracking; ask once, save preference in `wiki/profile/preferences.md`).
3. Compare to previous session of same exercise. Note PR or stall.
4. If recovery context known (Oura), reflect whether the planned intensity matched recovery.
5. Append to `log.md`: `## [DATE TIME] workout-log | <type>: <summary>`.

### Symptom log

User: "headache since lunch" or "energy crashed at 3pm" or "bloated after dal" or "great mood today"

1. Append to today's log under Symptoms section. Include time of day if relevant.
2. If recurring (3+ times in 14 days), note in `wiki/reviews/correlations/` and consider invoking `review` correlation sub-flow on next session.
3. Append to `log.md`: `## [DATE TIME] symptom | <text>`.

### Beverage log

User: "had 4 chais today" or "2 cups coffee" or "3 glasses water" or "2 pegs whisky"

1. Update Beverages section of today's log.
2. Compute hidden calories (sugar chai ~60 kcal each with 2 tsp sugar, +30 with milk; black coffee ~5; alcohol per peg ~80).
3. Add to Daily Totals if material.
4. Append to `log.md`: `## [DATE TIME] beverage | <summary>`.

### Supplement log

User: "took my B12 and Vit D" or "skipped omega-3" or "started new magnesium"

1. Update Supplements section of today's log (or add the section if not yet in template).
2. Cross-reference `wiki/profile/supplements.md` for what's expected.
3. If skipped, note. If pattern emerges (skipped >3x/week), surface in next monthly checkin.
4. If new supplement: prompt to add to `wiki/profile/supplements.md` with brand/dose/timing.
5. Append to `log.md`: `## [DATE TIME] supplement | <taken/skipped/added>`.

## End-of-day close

When the user signals end of day ("done eating", "closing out the day", evening reflection complete, or at midnight on the next session), finalize today's daily log:

1. Write the "Daily totals" section with kcal_actual / kcal_target, protein_actual / target, fiber, sodium estimate.
2. Write the YAML frontmatter block at the top of the file per the Frontmatter contract in CLAUDE.md:
   ```yaml
   ---
   date: YYYY-MM-DD
   kcal_actual: <int>
   protein_g_actual: <int>
   fiber_g_actual: <int>
   weight_kg: <float>        # only if weighed today
   energy_score: <1-10>      # if logged
   sleep_hours: <float>      # if logged
   sleep_score: <1-10>       # if logged
   workout: <true|false>
   ---
   ```
   This block is what powers the Obsidian dashboard's "Today" panel and 30-day adherence view. Without it, the day shows as "no data."
3. Append to `log.md`: `## [DATE TIME] note | day closed, <one-line summary>`.

## Bookkeeping (always)

After every log event:
1. Today's daily log file is updated (or created from template).
2. Append to `log.md` with the right `kind`.
3. If a new food was added to food-library, update `index.md`.
4. Refresh `hot.md` only if event is materially recent context (new weight, new PR, recurring symptom, biomarker-relevant beverage pattern).
5. Cross-link related wiki pages (e.g., a Saoji entry → vidarbha-cuisine.md when that exists).
6. If the event is a weigh-in or body-comp measurement, the relevant frontmatter block in `wiki/profile/anthropometry.md` was updated in the same edit (see Weight log / Body measurements sub-flows).
