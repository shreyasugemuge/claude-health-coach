# Day zero: YYYY-MM-DD (template)

The founding session for your personal vault. Captures what you decided and why, so future redesigns have context. **Not auto-loaded in any session.** Reference only when revisiting a design choice or onboarding a collaborator.

Replace the placeholders below with your own founding context. Save as `wiki/design/YYYY-MM-DD-day-zero.md` in your personal vault.

## Context

User: [your name, role, location, age range, broad health context]

Founding ask: [why you built this; what problem it solves]

Stated user preferences (the things you'll bend the system around):
- [adherence vs precision tradeoff]
- [favorite foods that need to fit in any plan]
- [cuisine context: regional, religious, dietary]
- [non-negotiables: religious, allergies, time, budget]

## Founding goals

A system that:
1. [what should this do for you, year-one]
2. [what's the marker of success at 3 months / 6 months / 12 months]
3. [what does "won" look like]

## Key design decisions (and why)

Document the choices. Common topics worth recording:

- **LLM Wiki pattern adoption**: persistent compounding context vs RAG re-derivation
- **Region/cuisine specificity**: thresholds, dietary guidelines, food databases
- **Skills vs slash commands**: natural language vs explicit invocation
- **Stale-section watch**: which files degrade if not refreshed, and how often
- **Photo accuracy expectations**: what to communicate to the user
- **Adherence design principles**: deficit ceiling, weekly change rate, walking emphasis
- **Phasing**: P0 schema only, P1 knowledge cheatsheets, P2 MCP integrations
- **Privacy posture**: local only, private remote, encryption

## What was deferred

Features noted but not built. Includes the why: usually "wait until we need it" or "depends on a tool we don't have yet."

## Open questions

Things to revisit at the next quarterly checkin or annual review.

## How to use this document

This is design history, not active context. Reference when:
- Revisiting a design choice ("why did we go with X?")
- Onboarding a new collaborator
- Pruning a feature (you should know why it was added before removing)
- Doing the annual review (look back at year-zero intent)

Do not auto-load this in any session. The model can read it on demand if a question requires the founding context.

To rebuild your vault from scratch, this document plus the framework plus your wiki/profile/* and wiki/biomarkers/* should be sufficient.
