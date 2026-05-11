---
name: plan
description: Suggest what to eat, what to cook, what to order, when and how to work out. Plan dinner, day, or week. Brief the cook with a one-page menu. Decode a restaurant menu against current macros. Fit a specific desired food (the McDonald's wrap protocol). Pre-mortem upcoming events (wedding, travel, festival, vrat). Pick workout intensity from Oura recovery score. Invoke when the user says "plan dinner", "plan tomorrow", "plan the week", "what should I eat", "want X tonight", "can I have X", "is X OK to eat tonight", "brief the cook", "what do I tell the cook", "decode this menu", "what can I order at X", "wedding Saturday", "going to Mumbai 15-18", "fasting tomorrow", "vrat", "Ekadashi", "what workout today", "should I lift today", "/plan ...". Reads today's log + remaining macros + inventory + preferences + calendar + recovery before suggesting anything.
---

# Plan skill

Make suggestions that fit the user's current state. Always read today's log + remaining macros + inventory + preferences + calendar before suggesting.

## Pre-flight

If `wiki/profile/identity.md` is empty, run `checkin` first (onboarding mode). No plans without a profile.

If today's daily log file doesn't exist, create it from template (so remaining-macros math works).

## Sub-flows

### Plan dinner (or lunch / breakfast)

1. Read today's log → compute remaining macros (kcal, protein, fiber).
2. Read `wiki/profile/inventory.md` → what's available.
3. Read `wiki/profile/preferences.md` → what to favor / avoid.
4. Read `wiki/profile/kitchen.md` → who cooks, how much time, this day's typical dish.
5. Read `wiki/calendar/personal-events.md` → any events tomorrow that need pre-budgeting.
6. Suggest 2 to 3 ranked options. For each: name (with Hindi/Marathi where relevant), ingredients, prep time, macros, why it fits today specifically.
7. If user picks one, save as a meal-template at `wiki/plans/templates/<slug>.md` if it isn't already.
8. Append to `log.md`: `## [DATE TIME] plan | <slot> for <date>: <chosen option>`.

### Plan day / week

Same but for full B/L/D + snacks. Respect kitchen rotation. Pre-budget 1 to 2 splurges per week (favorites). Generate or update `wiki/plans/current-week-meals.md`.

For weekly: also check `wiki/calendar/` for festivals/vrat/events that fall in the week and pre-adjust those days.

Append `## [DATE TIME] plan | week-meals updated` to `log.md`.

### Brief the cook

User: "brief the cook for tomorrow" / "what do I tell her tomorrow"

1. Read tomorrow's plan from `wiki/plans/current-week-meals.md`.
2. Generate a one-page brief with:
   - Dish names in Hindi/Marathi (English in parentheses if helpful)
   - Ingredients with quantities (per dish)
   - Cooking method note (one line per dish)
   - Portion sizes for the user (and family if applicable)
   - Substitutions if an ingredient is missing (read inventory)
3. Format for printing: clean, no jargon, simple language she can follow.
4. Save as `wiki/plans/cook-briefs/YYYY-MM-DD.md`.
5. Print to chat for the user to copy/print.
6. Append `## [DATE TIME] brief-cook | for YYYY-MM-DD` to `log.md`.

### Decode a restaurant menu

User: "decode this menu" + photo, OR "what can I order at McDonald's / Saoji place / Subway / Domino's"

1. Read today's log → remaining macros.
2. Identify menu items.
   - Known restaurants (McD India, Subway India): pull from `wiki/food-library/eating-out/<restaurant>.md` if cached. If not cached, build the cache file on first use, citing the official PDF (McD: https://mcdindia.com/wp-content/uploads/2025/01/all-product-nutritional-information_cprl_main-store.pdf, Subway India PDF link in CLAUDE.md sources). 
   - Unknown places: estimate macros honestly with a wide confidence band.
3. Output a "best to worst" list with macros per item, highlighting:
   - Best fit for today's remaining budget
   - Best protein density
   - Worst macro traps (high oil, hidden sugar, low protein)
   - Acceptable splurge ceiling (one item you can have today and stay in range)
4. Save the decode to `wiki/food-library/eating-out/<restaurant>.md` for reuse.
5. Append `## [DATE TIME] decode-menu | <restaurant>` to `log.md`.

### Fit a desired food (the McDonald's wrap protocol)

User: "want McSpicy Paneer Wrap tonight" or "can I have biryani for lunch" or "I'm craving rasgulla"

1. Pull macros for the desired item from food-library, or estimate (cite source).
2. Read today's log → remaining macros.
3. Compute: does it fit?
4. If yes: confirm and suggest the rest of the day's eating to stay aligned.
5. If no, suggest 2 to 3 fitting moves:
   - Skip a planned snack (give specifics)
   - Reduce portion of an upcoming meal (specific reduction)
   - Add a 30 min walk to expand budget (~150 to 200 kcal)
   - Bank for tomorrow and adjust tomorrow's plan accordingly
6. Honor adherence principles: bake favorites in, do not moralize. The wrap fitting is the killer feature.

### Event pre-mortem

User: "wedding Saturday" / "travel to Delhi 15-18" / "vrat tomorrow" / "Ekadashi this Friday"

1. Add to `wiki/calendar/personal-events.md` with type + dates.
2. Adjust the affected days in `wiki/plans/current-week-meals.md`:
   - **Wedding**: lighter B/L on the wedding day to leave room. Strategic ordering tips at the venue (lean on tandoori starters, avoid butter gravies, salad first, dessert as one item not three).
   - **Travel**: switch to maintenance calories for trip duration. Regional cuisine notes if known city (Mumbai street, Delhi parathas, Hyderabad biryani). Hotel/airport survival kit (look for grilled, paneer, eggs, dal, salads).
   - **Vrat / Ekadashi / Navratri**: switch to vrat-foods plan (sabudana, kuttu, singhara, samak rice, peanuts, potatoes, fruits, dairy). Hydration emphasis. Time the eating window if user observes specific rules.
   - **Festival** (Diwali, Holi, Ganesh Chaturthi etc.): pre-budget the sweets and fried snacks expected. Reduce other-meal calories by ~150 to 200 kcal/day for the festival window.
3. Append `## [DATE TIME] event-add | <type>: <name>, <dates>` to `log.md`.
4. Refresh `hot.md`.

### Workout intensity (recovery-aware)

User: "what workout today" / "should I lift today"

1. Read latest Oura recovery from `wiki/biomarkers/sleep-recovery.md` (if recent).
2. Read `wiki/plans/current-week-workouts.md` for today's planned session.
3. Decision rule:
   - Recovery score ≥85 → push: planned session, possibly add a set or +2.5 kg.
   - Recovery 70 to 84 → maintain: planned session as-is.
   - Recovery 50 to 69 → modify: lower intensity, drop one accessory, focus on form.
   - Recovery <50 → restore: skip lifting, do mobility + 30-min walk.
4. Also check AQI for outdoor workouts. If AQI >150 (Nagpur paddy-burning season Oct-Nov, or Delhi/Mumbai winter), recommend indoor alternative.
5. Note today's intensity decision in today's daily log under Movement.
6. Append `## [DATE TIME] plan | workout: <decision> based on recovery <X>, AQI <Y>` to `log.md`.

## Bookkeeping (always)

After every plan event:
1. Append to `log.md` with right kind (`plan`, `brief-cook`, `decode-menu`, `event-add`).
2. If a new food-library entry was created, update `index.md`.
3. Refresh `hot.md` if plan is for today/tomorrow.
