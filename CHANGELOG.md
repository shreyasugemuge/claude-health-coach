# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows [SemVer](https://semver.org/).

## [0.2.0] 2026-05-11

Adds an optional read-only UI surfaced inside Obsidian, powered by YAML frontmatter that Claude maintains automatically. No web server, no SQLite, no new build tools. Two community plugins (DataView + Obsidian Charts) and a single `dashboard.md` file.

### Added
- **"Frontmatter contract" section in `CLAUDE.md`**: defines the YAML frontmatter schemas for four file types (`wiki/profile/anthropometry.md`, `wiki/targets/current.md`, `wiki/biomarkers/*.md`, daily logs at end-of-day). Single source of truth for how the body and machine-readable frontmatter stay in sync.
- **`wiki-template/dashboard.md`**: a DataviewJS dashboard with five panels (Today macros, Weight trend chart, Latest biomarkers snapshot with color-coded thresholds, 30-day adherence table, Recent activity feed from `log.md`).
- **Daily log template now includes an end-of-day frontmatter block** (CLAUDE.md). Written once per day when the "Daily totals" section is finalized.
- **Skill updates**:
  - `log`: on weigh-in, also appends to `weight_log` frontmatter array. On body-comp, also appends to `waist_log`. New "End-of-day close" sub-flow writes the daily log frontmatter.
  - `ingest`: on bloodwork ingest, also updates the biomarker file's `log` array and `latest` block in frontmatter.
  - `checkin`: target changes now rewrite the targets file's frontmatter alongside the body table.
- **Bookkeeping rule 5** in CLAUDE.md: explicit "update frontmatter when the operation is a weigh-in, body-comp, bloodwork ingest, target change, or end-of-day close."
- **README**: new "Obsidian dashboard (optional UI)" section explaining plugin install, dashboard copy step, and how the frontmatter layer works.
- Sample vault files (`anthropometry.md`, `targets/current.md`, `biomarkers/lipid.md`, `logs/2026/05/09.md`) now demonstrate the frontmatter format.

### Design notes
- Claude remains the primary writer. The dashboard is read-only; no write-back forms.
- Frontmatter is additive on the four target files. The rest of the wiki (`log.md`, `hot.md`, `index.md`, profile prose, plans, reviews) is unchanged.
- Append-only invariant preserved: weight and biomarker logs accumulate tuples; targets rewrites are wholesale; daily log frontmatter is written once per day.

## [0.1.1] 2026-05-11

### Added
- `examples/framework-hooks/` with `pre-commit`, `pre-push`, `install.sh`, and README. Tracked versions of the framework-side git hooks that previously lived only in untracked `.git/hooks/`. Contributors can now install them with one command.
- README cross-references to both `examples/framework-hooks/` and `examples/vault-hooks/`.

### Changed
- `pre-push` sensitive-content pattern tightened to `LDL XX mg/dL` (was `LDL XX mg`) to reduce false positives on prose like "LDL <100 mg/dL".

## [0.1.0] 2026-05-11

First public release. The framework is usable end-to-end for personal health, nutrition, and fitness coaching with Claude Code, scoped to Indian (Maharashtra / Vidarbha) defaults but adaptable.

### Added
- `CLAUDE.md` schema with two-mode awareness (FRAMEWORK DEV vs PERSONAL VAULT), India-specific defaults (IFCT 2017, ICMR DGI 2024, LAI 2024, Asian-Indian thresholds), adherence design principles, daily log template, and stale-section watch list.
- `llm-wiki.md` reference essay explaining the underlying LLM Wiki pattern.
- Six auto-triggering skills under `.claude/skills/`:
  - `help`, `checkin`, `log`, `plan`, `ingest`, `review`.
- Six namespaced slash command shortcuts under `.claude/commands/health/`:
  - `/health:help`, `/health:checkin`, `/health:log`, `/health:plan`, `/health:ingest`, `/health:review`.
- Mode-aware Claude Code PreToolUse hook at `.claude/hooks/enforce-mode-boundary.sh`. Blocks edits to framework files from a vault and writes to personal-data paths from the framework.
- `examples/vault-hooks/` with `pre-commit`, `pre-push`, and `install.sh`. Vault `pre-push` refuses to push to a PUBLIC GitHub remote.
- `examples/sample-vault/` sanitized fake-user vault demonstrating the file shapes (identity, goals, anthropometry, lipid biomarker, targets, daily log, index, hot, log).
- `wiki-template/design-example.md` template for day-zero design logs.
- Framework `.gitignore` aggressively blocking every personal-data path.
- README with two-repo install recipe and safeguard documentation.
- MIT license.

### Known limitations
- Knowledge cheatsheets under `wiki-template/knowledge/` are stubs. The 16 planned cheatsheets (IFCT cheatsheet, ICMR DGI 2024, India thresholds, thin-fat phenotype, flexible dieting, GI India, NAFLD India, B12/D deficiency, Vidarbha cuisine, workout progression, India festivals, vrat foods, Oura recovery interpretation, psychology of adherence, AQI workout, Indian snack culture) are P1.
- No automated tests for skills or the hook script yet (manual only).
- Wearable MCP integration (Apple Health, Oura) not wired; manual export to `raw/wearable-exports/` is the current workflow.
- No CI.
