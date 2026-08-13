Fills `{{ISSUE_WORKFLOW}}` when project tracks issues on GitHub. Copy body below (under the rule) into AGENTS.md's gate 1b section.

---

- Search `gh issue list` + closed issues for same goal; read any candidate with `sh .claude/scripts/issue-view.sh <number>`, never raw `gh issue view`. Reuse + reference its number; never open a second. Else draft, get approval, `gh issue create`.
- Title: plain language a maintainer can scan. Not a slug, ID, or commit subject.
- Self-contained (spec not pushed yet): quote full normative text beside each new ID, each changed requirement as old → new, plus `api-contract.md`/`edge-cases.md` entries. ID with no text is useless.
- Goal + normative changes only. No implementation detail (structure/files/functions/approach) — belongs to gate 2 and PR.
- `##` sections, not prose: `## Background`/`## Why`, `## Scope`, `## Goal`, more as warranted. Compact enumerations, grouped ID ranges. Same shape for PR bodies.
- Never edit the issue body after filing — append updates with `gh issue comment`.
