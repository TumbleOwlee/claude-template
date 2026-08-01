Fills `{{ISSUE_WORKFLOW}}` when the project has no issue tracker. Copy the body
below (everything under the rule) into AGENTS.md's gate 1b section.

---

This project has no issue tracker, so there is no issue to open — but the goal still
gets written down before implementation starts, and it still gets approved.

- Draft the goal statement and **stop for approval**: `## Background`/`## Why`,
  `## Scope`, `## Goal`, in plain language a maintainer can scan.
- Self-contained — quote the full normative text beside each new ID, and each changed
  requirement as old → new. An ID with no text is useless to a reader.
- Goal and normative changes only. No implementation detail (structure, files, functions,
  approach) — that belongs to gate 2 and the PR.
- Carry the approved text into the PR body at gate 4 as its opening sections, so the
  merged history records what was asked for as well as what was built.
