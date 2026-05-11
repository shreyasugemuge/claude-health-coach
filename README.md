# Claude Health Coach

[![release](https://img.shields.io/badge/release-v0.1.0-blue)](./CHANGELOG.md) [![license](https://img.shields.io/badge/license-MIT-green)](./LICENSE) [![built for](https://img.shields.io/badge/built%20for-Claude%20Code-orange)](https://claude.ai/code)

A personal health, nutrition, and fitness coaching framework for [Claude Code](https://claude.ai/code). India-first defaults (IFCT 2017 macros, ICMR DGI 2024 caps, LAI 2024 lipid targets, Asian-Indian anthropometric thresholds), adaptable to any cuisine.

Built on the [LLM Wiki pattern](./llm-wiki.md): a personal knowledge base that Claude incrementally builds and maintains across sessions, instead of re-deriving from RAG every query.

## What it does

You talk to Claude in natural language. It routes to one of six skills:

| Skill | What it handles | Example phrases |
|---|---|---|
| `log` | Meals (text or photo), weight, body comp, workouts, symptoms, chai/coffee, supplements. | "had 2 phulkas and palak paneer for lunch", "weighed 68.2", drop a food photo |
| `plan` | Day / week meals, briefing the cook, decoding restaurant menus, fitting a desired food, pre-mortems for festivals or travel, recovery-aware workouts. | "plan dinner", "decode this Saoji menu", "wedding Saturday" |
| `ingest` | Bloodwork PDFs, medical reports, wearable exports (Apple Health / Oura / Apple Watch), grocery receipts, body comp photos, inbox notes. | drop a PDF in `raw/`, "ingest my Oura export" |
| `review` | Weekly / monthly / quarterly / annual reviews, biomarker-event analysis, correlations, lint, risk projection, pattern charts. | "weekly review", "where am I headed", "lint" |
| `checkin` | Onboarding (first session, auto-runs), periodic structured interviews. | "let's start", "weekly checkin" |
| `help` | Tour of the project. | "help", "what can you do" |

Each skill auto-triggers from natural language via its description; no slash commands required. Namespaced slash commands (`/health:log`, `/health:plan`, etc.) are available if you prefer explicit invocation.

## What this repo contains, and what it doesn't

This repo is the **framework**, not your personal vault.

In here:
- `CLAUDE.md`, the schema Claude reads every session (with mode-detection logic).
- `llm-wiki.md`, reference essay on the underlying pattern.
- `.claude/skills/` and `.claude/commands/health/`, six skills and six slash commands.
- `.claude/hooks/enforce-mode-boundary.sh`, mode-aware PreToolUse hook.
- `wiki-template/`, day-zero design template and the (P1) knowledge cheatsheet stubs.
- `examples/vault-hooks/`, recommended git hooks for your private vault.
- `examples/sample-vault/`, a tiny sanitized fake-user vault so you can see the shape before you onboard.

Not in here, by design: any personal data. Your bloodwork, food logs, body comp photos, profile, goals, plans live in your **separate private vault**.

## Two-repo architecture

```
~/Code/claude-health-coach/    THIS REPO (framework, public-shareable)
~/health-vault/                YOUR PERSONAL VAULT (private)
                               symlinks to the framework for shared bits,
                               real files for your data
```

This separation guarantees:
- Pushing a framework change cannot leak personal data (it physically does not exist here).
- Pulling framework updates cannot conflict with your data (different paths, no merge).
- Your data stays on your machine (or a private remote of your choice).

## Install

```bash
# 1. Clone this framework
git clone https://github.com/shreyasugemuge/claude-health-coach ~/Code/claude-health-coach

# 2. Create your personal vault (separate dir)
VAULT=~/health-vault
mkdir -p "$VAULT"/{raw/{bloodwork,medical,photos/body,wearable-exports,grocery-receipts,inbox},wiki/{profile,biomarkers,logs,targets,plans/templates,food-library/{home,eating-out,packaged},calendar,reviews/{weekly,monthly,quarterly,annual,biomarker-events,correlations},design}}
cd "$VAULT"

# 3. Symlink the framework files into your vault
ln -s ../Code/claude-health-coach/CLAUDE.md CLAUDE.md
ln -s ../Code/claude-health-coach/llm-wiki.md llm-wiki.md
ln -s ../Code/claude-health-coach/.claude .claude
ln -s ../../Code/claude-health-coach/wiki-template/knowledge wiki/knowledge

# 4. Mark this dir as a personal vault (so CLAUDE.md mode-detection works)
touch .is-personal-vault

# 5. Bootstrap the vault's catalog files
cat > index.md <<'EOF'
# Wiki index
(this vault's catalog; will grow as you onboard)
EOF

cat > hot.md <<'EOF'
# Hot context (PERSONAL VAULT)
Rolling 14-day cache. Read first every session.
EOF

cat > log.md <<'EOF'
# Event log (PERSONAL VAULT)
Append-only. Format: `## [YYYY-MM-DD HH:MM] kind | summary`.
EOF

# 6. Init the vault as YOUR PRIVATE git repo
git init -b main
echo ".DS_Store" > .gitignore
git add .
git commit -m "init my personal vault"

# 7. (Recommended) install the vault-side git hooks
sh ~/Code/claude-health-coach/examples/vault-hooks/install.sh

# 8. (Optional) copy the dashboard into your vault for the Obsidian UI
cp ~/Code/claude-health-coach/wiki-template/dashboard.md dashboard.md

# 9. Open in Claude Code
claude
```

Then talk to it: "let's start" runs onboarding.

## Obsidian dashboard (optional UI)

Claude is the coach. The dashboard is a read-only window on what Claude has already written, surfaced in Obsidian alongside your editor.

What it shows:
- **Today**: kcal and protein progress vs your current targets.
- **Weight trend**: line chart of the last 60 weigh-ins from `wiki/profile/anthropometry.md`.
- **Latest biomarkers**: snapshot table colored against LAI 2024 / ICMR cutoffs.
- **30-day adherence**: per-day kcal, protein, weight, and a green/yellow/red band.
- **Recent activity**: last 20 entries from `log.md`.

Setup, one time:

1. Install [Obsidian](https://obsidian.md/) and open your vault directory as an Obsidian vault.
2. Install the two community plugins from inside Obsidian (Settings → Community plugins):
   - **Dataview** (ID: `dataview`)
   - **Obsidian Charts** (ID: `obsidian-charts`)
3. Copy `dashboard.md` from `wiki-template/` into your vault root (step 8 of the install above does this).
4. Open `dashboard.md` in reading view.

How the data layer works:

Claude maintains a YAML frontmatter block at the top of four file types (`wiki/profile/anthropometry.md`, `wiki/targets/current.md`, `wiki/biomarkers/*.md`, today's `wiki/logs/YYYY/MM/DD.md` at end-of-day). The dashboard's DataView queries read those blocks directly. The full schema and update rules live in the "Frontmatter contract" section of `CLAUDE.md` so every Claude session knows the contract. You never edit frontmatter by hand; the skills (`log`, `ingest`, `checkin`) write both the human-readable body and the machine-readable frontmatter in the same edit.

See [`examples/sample-vault/`](./examples/sample-vault/) for example files with the frontmatter populated.

## Updating the framework

```bash
cd ~/Code/claude-health-coach
git pull origin main
```

Your vault sees the changes immediately through its symlinks. **No merge ever, because the framework and the vault never edit the same files.**

## Mode awareness

Both modes share a single `CLAUDE.md`. It detects mode at session start by checking for `.is-personal-vault` in the project root:

- Marker present (you're in your vault): full coaching mode.
- Marker absent (you're here in the framework): development mode, no personal-data writes, no onboarding.

## Safeguards (three layers)

If you accidentally try to log a meal in the framework, or edit a skill from your vault, you get blocked. Three nested layers:

| Layer | Where | When it fires | What it does |
|---|---|---|---|
| **Claude Code PreToolUse hook** | `.claude/hooks/enforce-mode-boundary.sh` | Before `Edit`/`Write`/`MultiEdit`/`NotebookEdit` runs | Reads the file path, checks for `.is-personal-vault` marker in `$CLAUDE_PROJECT_DIR`, blocks the wrong combination with a clear message and `exit 2`. |
| **`.gitignore`** | Framework: aggressive (blocks personal-data paths). Vault: minimal (tracks personal data for backup). | When `git add` runs | Personal-data paths cannot enter the framework's index. |
| **`pre-commit` + `pre-push`** | Both `.git/hooks/` | At commit and push time | Last line of defense. Framework hooks block personal-data paths and sensitive content patterns; vault `pre-push` refuses pushes to PUBLIC GitHub remotes. |

First time a Claude Code session loads this project, you'll be asked to approve the hook configuration. Approve once and it stays.

If you forked this repo or plan to contribute, install the framework-side git hooks once:

```sh
sh examples/framework-hooks/install.sh
```

See [`examples/framework-hooks/`](./examples/framework-hooks/) and [`examples/vault-hooks/`](./examples/vault-hooks/) for the two installers.

## Sample vault

See [`examples/sample-vault/`](./examples/sample-vault/) for a tiny sanitized fake-user vault. Useful for understanding the file shapes before you onboard for real.

## Honest disclosure

- I am one user, not a venture-backed wellness product. This is my real working setup, opened up. Maintained as time allows.
- Photo-calorie estimates from any LLM (this one included) sit in a ±35-40% band for kcal and ±60% for protein on a single mixed-Indian meal. The trend over weeks is what matters. The framework communicates this honestly every time.
- Claude is not a doctor. The framework surfaces signals against established thresholds (LAI 2024, ICMR DGI 2024, ADA 2026, IFCT 2017). For genuinely abnormal values, see a physician.

## Roadmap

See [`CHANGELOG.md`](./CHANGELOG.md) for what shipped. P1 candidates:

- The 16 India-specific knowledge cheatsheets under `wiki-template/knowledge/` (IFCT, ICMR, thin-fat phenotype, NAFLD, Vidarbha cuisine, vrat foods, Oura interpretation, AQI workouts, etc.).
- Wearable MCP integration (Apple Health, Oura).
- Cuisine packs (Tamil, Bengali, Punjabi additive packs).
- Automated tests for skills and hook script.

## Contributing

See [`CONTRIBUTING.md`](./CONTRIBUTING.md). PRs welcome for skills, cheatsheets, hook robustness, and cuisine packs. Probably-decline for cloud sync, telemetry, web UIs.

## License

MIT. See [`LICENSE`](./LICENSE).
