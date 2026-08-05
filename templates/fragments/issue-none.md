Fills `{{ISSUE_WORKFLOW}}` when project has no issue tracker. Copy body below (under the rule) into AGENTS.md's gate 1b section.

---

No issue tracker → no issue to open, but the goal is still written down and approved before implementation starts.

- Draft goal statement, **stop for approval**: `## Background`/`## Why`, `## Scope`, `## Goal`, plain language a maintainer can scan.
- Self-contained: quote full normative text beside each new ID, each changed requirement as old → new. ID with no text is useless to a reader.
- Goal + normative changes only. No implementation detail (structure/files/functions/approach) — belongs to gate 2 and PR.
- Carry approved text into PR body at gate 4 as its opening sections, so merged history records what was asked for and what was built.
