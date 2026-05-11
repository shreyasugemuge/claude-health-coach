# Contributing

Thanks for the interest. A few ground rules.

## What this project is

A personal-health coaching framework for [Claude Code](https://claude.ai/code), with India-first defaults (IFCT 2017, ICMR DGI 2024, LAI 2024, Asian-Indian thresholds). It is one user's working setup, opened up. Maintained as time allows. Not a venture-backed product.

## What this repo contains, and what it does not

This repo is the **framework**: schema (`CLAUDE.md`), skills, slash commands, hooks, templates, examples. It contains **no personal data**, by design and by enforcement:

- `.gitignore` blocks every personal-data path (`wiki/profile/`, `wiki/biomarkers/`, `wiki/logs/`, `raw/`, etc.).
- The Claude Code PreToolUse hook blocks writes to those paths when in framework mode.
- Reviewers should reject any PR that adds personal-data paths under the listed prefixes.

If you have a real vault, keep it in a separate private repo. See the README for the two-repo layout.

## Reporting issues

Open a GitHub issue. Useful detail: which mode (framework vs vault), what you tried, what happened, what you expected. If the hook script misbehaves, paste the blocked path and the hook's stderr.

## Pull requests

PRs welcome for:

- Skill improvements (clearer descriptions, better routing, bug fixes).
- New knowledge cheatsheets under `wiki-template/knowledge/` (IFCT cheatsheet, NAFLD India, etc., see the P1 list in `CLAUDE.md`).
- Documentation and README clarity.
- Hook robustness across shells and macOS / Linux.
- Cuisine packs (e.g., a Tamil or Bengali defaults pack) under `wiki-template/knowledge/`. Keep India-first; other cuisines via additive packs.

Probably-decline PRs:

- Cloud sync, account systems, telemetry.
- Anything that changes the two-repo separation to a single-repo "mode flag."
- Web UIs. This is a CLI + Claude Code setup; the editor / chat is the UI.

## Writing style

- No em dashes (—) or en dashes (–) anywhere in documentation, code comments, commit messages, PR descriptions. Use commas, colons, semicolons, parentheses, or full stops instead. Regular hyphens in compound words and paths are fine.
- Plain English. Hindi and Marathi food names preferred for Indian dishes when relevant.
- Cite sources. Coaching content without a citation tends to drift.

## Testing changes

There is no automated test suite yet. Manual testing:

1. Make your change in this repo.
2. From a separate personal vault (or `examples/sample-vault/` copied to a scratch dir with the right symlinks and `.is-personal-vault` marker), run Claude Code and exercise the affected skill or hook.
3. For hook changes, simulate both modes: with and without the `.is-personal-vault` marker present.

## Privacy expectations

This is a medical-data-adjacent project. Treat any sample data in PRs as if it could be misread as real. Use fictional names, fictional values. The repo enforces personal-data path blocks; please do not try to circumvent them in a contribution.

## License

By contributing, you agree your contributions are licensed under the [MIT license](./LICENSE).
