# Sample vault (sanitized)

A tiny fake-user vault to show the shape of a real one without forcing you to run onboarding before you can see anything.

**Persona:** Asha, 38F, Pune, vegetarian, mild PCOS, mother of two, sedentary desk job. All values are fictional.

What this demonstrates:

- `wiki/profile/identity.md`, `wiki/profile/goals.md`, `wiki/profile/anthropometry.md` populated after onboarding.
- `wiki/targets/current.md` showing the calorie + protein targets a real coach would compute.
- `wiki/biomarkers/lipid.md` showing how a bloodwork ingest writes a biomarker page.
- `wiki/logs/2026/05/09.md` showing a daily log mid-day.
- `index.md`, `hot.md`, `log.md` showing the three top-level catalog files.

What this is NOT:

- Not a working vault. The `.claude/` and framework symlinks are not present here, so opening this directory in Claude Code will not do anything useful. Copy the files into your real vault structure if you want to crib formats.
- Not real data. Do not infer Indian thresholds, recipe macros, or coaching judgments from these numbers; consult the actual schema (`CLAUDE.md`) and references (IFCT 2017, ICMR DGI 2024, LAI 2024).
