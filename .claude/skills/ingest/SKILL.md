---
name: ingest
description: Process any file dropped into raw/. Bloodwork PDFs (parse values, normalize units, compare to India thresholds, update biomarkers, generate biomarker-event review). Medical PDFs (extract diagnoses, update profile/medical). Wearable exports (Apple Health zip, Oura csv, Apple Watch). Grocery receipts from Zepto/BigBasket/Blinkit (OCR, update inventory, flag restock items). Body composition photos (file under raw/photos/body/, update biomarkers/body-composition). Random notes from raw/inbox/ (triage to right destination). Invoke when the user drops a file, says "ingest X", "I uploaded my bloodwork", "here's my report", "I dropped my Oura export", "process inbox", "parse this PDF", or when a file appears in raw/ that hasn't been processed yet (check log.md for last ingest event of each filename).
---

# Ingest skill

Process any file in `raw/`, integrate findings into the wiki. NEVER modify the raw file.

## File-type routing

| Path / extension | Sub-flow |
|---|---|
| `raw/bloodwork/*.pdf` | Bloodwork ingest |
| `raw/medical/*.pdf` | Medical report ingest |
| `raw/wearable-exports/*.zip` (Apple Health) | Apple Health ingest |
| `raw/wearable-exports/*.csv` (Oura) | Oura ingest |
| `raw/wearable-exports/*.csv` (Apple Watch) | Apple Watch ingest |
| `raw/grocery-receipts/*.{jpg,pdf,png}` | Receipt OCR |
| `raw/photos/body/*.{jpg,png}` | Body comp photo |
| `raw/inbox/*` | Triage |

## Bloodwork ingest

1. Read the PDF (use Read tool; pages parameter if PDF >10 pages).
2. Identify lab provider (Thyrocare, Healthians, Lal PathLabs, Metropolis, etc.) from the header.
3. Extract every value: name, unit, reference range, the user's value.
4. Normalize units (e.g., glucose mg/dL vs mmol/L; B12 pg/mL vs pmol/L).
5. Update biomarker files with timestamped rows:
   - Lipid panel → `wiki/biomarkers/lipid.md`
   - HbA1c, FPG, insulin, C-peptide → `wiki/biomarkers/glycemic.md`
   - LFT (ALT, AST, GGT, ALP, bilirubin) → `wiki/biomarkers/liver.md`
   - TSH, T3, T4, anti-TPO → `wiki/biomarkers/thyroid.md`
   - B12, Vit D, ferritin, iron, magnesium, folate → `wiki/biomarkers/micronutrients.md`
   - Creatinine, urea, eGFR, uric acid → `wiki/biomarkers/kidney.md`
   - CBC (Hb, WBC, platelets, RBC indices) → `wiki/biomarkers/cbc.md`
6. Compare against India thresholds in CLAUDE.md (LAI 2024 lipid, ICMR/ADA glycemic, India-specific micronutrient cutoffs). Flag abnormals.
7. If any value triggers a diagnosis or category change (e.g., HbA1c crosses 5.7 → prediabetes, LDL crosses 100 → at-risk, B12 <200 pg/mL → deficient), update `wiki/profile/medical.md` and consider whether `wiki/targets/current.md` needs adjustment.
8. Generate `wiki/reviews/biomarker-events/YYYY-MM-DD-<labname>.md`:
   - What changed since last reading (diff)
   - What's now flagged
   - What in the diet/lifestyle plan should adjust
   - Recommended physician follow-up if anything is genuinely abnormal
9. Append to `log.md`: `## [DATE TIME] ingest | bloodwork from <lab>, <N abnormals>`.
10. Append to `log.md`: `## [DATE TIME] biomarker-event | <one-line summary>`.
11. Update `index.md` with the new biomarker-event page.
12. Refresh `hot.md` with the key change.

## Medical report ingest

1. Read PDF.
2. Extract diagnoses, recommendations, prescribed medications, follow-up dates.
3. Update `wiki/profile/medical.md`. Cross-link to the source raw/ file (relative path).
4. If new medication: ask user about timing/dose if not in report; update `wiki/profile/supplements.md` (or split out a `wiki/profile/medications.md` if the list grows beyond ~5 items).
5. If a follow-up appointment is mentioned, add to `wiki/calendar/personal-events.md`.
6. Append `## [DATE TIME] ingest | medical report from <doc/specialty>` to `log.md`.

## Apple Health ingest (zip)

1. Acknowledge: "Apple Health export is large; I'll extract key signals."
2. Parse the XML inside the zip (or ask user to extract `export.xml` for you to read).
3. Pull: steps/day, resting heart rate, HRV, sleep stages and durations, weight (if synced), workouts.
4. Update `wiki/biomarkers/sleep-recovery.md` with new rolling averages.
5. Update `wiki/biomarkers/bp-resting-hr.md` with RHR trend.
6. Update `wiki/profile/anthropometry.md` if weight is synced and newer than the last manual entry (mark as "from Apple Health").
7. Append `## [DATE TIME] ingest | apple-health export, <date range>` to `log.md`.
8. Append `## [DATE TIME] sleep-ingest | <N nights>` to `log.md`.

## Oura ingest (csv)

1. Parse Oura csv: sleep score, readiness score, HRV, RHR, body temp deviation, sleep stages, activity score.
2. Update `wiki/biomarkers/sleep-recovery.md` with daily rows + computed weekly averages (sleep avg, readiness avg, HRV trend).
3. Append `## [DATE TIME] ingest | oura, <date range>` to `log.md`.
4. If readiness pattern is degrading (3+ low-readiness days in a week, or HRV trending down >10% over 2 weeks), surface in next checkin and flag in `hot.md`.

## Apple Watch ingest

Similar to Apple Health (same data sources usually). If Apple Watch data is in a separate file, merge with Apple Health on date keys.

## Receipt OCR

1. OCR the image/PDF.
2. Extract item list with quantities and prices. Note store (Zepto, BigBasket, Blinkit, Reliance, etc.).
3. Update `wiki/profile/inventory.md` (add new items, increment existing items' last-purchased timestamps).
4. Flag items running low (compare to typical pantry levels in `wiki/profile/kitchen.md`).
5. Compute meal cost contribution if helpful.
6. Append `## [DATE TIME] ingest | receipt from <store>, <N items>, ₹<total>` to `log.md`.

## Body comp photo

1. File the photo as `raw/photos/body/YYYY-MM-{front,side,back}.jpg` (rename if user dropped a generic filename).
2. Update `wiki/biomarkers/body-composition.md` with reference to the photo (relative link).
3. If user provided tape measurements alongside, log those too.
4. If a previous month's photo exists for the same view, describe visible changes qualitatively (do not over-claim; vision can't measure body fat from a photo).
5. Append `## [DATE TIME] ingest | body-comp photo, <view>` to `log.md`.

## Inbox triage

For each file in `raw/inbox/`:
1. Look at content (Read for text/markdown/PDF, view for images).
2. Decide destination:
   - Bloodwork PDF → move to `raw/bloodwork/`, then bloodwork ingest
   - Medical doc → move to `raw/medical/`, then medical ingest
   - Food photo → move to `raw/photos/`, then invoke `log` skill (meal-photo)
   - Body photo → move to `raw/photos/body/`, then body comp ingest
   - Receipt → move to `raw/grocery-receipts/`, then receipt OCR
   - Wearable export → move to `raw/wearable-exports/`, then matching ingest
   - Random text note → ad-hoc routing (could be a preferences update via `checkin` ad-hoc, a goal note, a symptom log via `log`, etc.)
3. Use `mv` (don't copy; the file's destination is its real home).
4. Invoke the appropriate sub-flow.
5. Append `## [DATE TIME] ingest | inbox triage: <filename> → <destination>` to `log.md`.

## Bookkeeping (always)

Every ingest:
1. Append to `log.md` with right `kind`.
2. Update `index.md` if new pages were created.
3. Refresh `hot.md` with the key change.
4. Cross-link the source raw/ file in the wiki page (relative path) so the user can audit.
