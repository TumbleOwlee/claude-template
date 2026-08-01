Fills `{{ISSUE_WORKFLOW}}` when the project tracks issues on GitHub. Copy the
body below (everything under the rule) into AGENTS.md's gate 1b section.

---

- Search `gh issue list` and closed issues for the same goal. Reuse what exists and
  reference its number; never open a second. Otherwise draft, get approval, `gh issue create`.
- Title: plain language a maintainer can scan. Not a slug, an ID, or a commit subject.
- Self-contained — the spec is not pushed yet, so quote the full normative text beside
  each new ID, each changed requirement as old → new, plus `api-contract.md` and
  `edge-cases.md` entries. An ID with no text is useless.
- Goal and normative changes only. No implementation detail (structure, files, functions,
  approach) — that belongs to gate 2 and the PR.
- `##` sections, not prose: `## Background`/`## Why`, `## Scope`, `## Goal`, more as
  warranted. Compact enumerations, grouped ID ranges. Same shape for PR bodies.
