Fills `{{ISSUE_WORKFLOW}}` when project tracks issues as local files, no external tracker. Copy body below (under the rule) into AGENTS.md's gate 1b section.

---

- No external tracker — the "issue" is a tracked file, `.claude/issues/<slug>.md`.
- Search `.claude/issues/` for an open issue with the same goal (no `Closed:`/`Resolved:` marker at top). Reuse + reference its filename; never create a second.
- Else draft, **stop for approval**, write `.claude/issues/<slug>.md`: `## Background`/`## Why`, `## Scope`, `## Goal`, plain language a maintainer can scan.
- Self-contained: quote full normative text beside each new ID, each changed requirement as old → new. ID with no text is useless to a reader.
- Goal + normative changes only. No implementation detail (structure/files/functions/approach) — belongs to gate 2 and PR.
- On merge (gate 4), prepend `Closed: <PR URL>` to the issue file's first line — keeps it out of the reuse search above without deleting history.
