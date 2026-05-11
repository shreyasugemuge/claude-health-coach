---
description: Process a file in raw/ (bloodwork, medical, wearable export, receipt, body photo, inbox)
argument-hint: [path/to/file | inbox]
---

Invoke the `ingest` skill.

- If $ARGUMENTS is a file path, ingest that file.
- If $ARGUMENTS is `inbox`, triage everything in `raw/inbox/`.
- If $ARGUMENTS is empty, scan `raw/` for files newer than the last `ingest` event in `log.md` and ingest them.
