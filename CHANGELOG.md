# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows [SemVer](https://semver.org/).

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
