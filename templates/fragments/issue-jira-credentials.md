Fills `{{ISSUE_WORKFLOW}}` when project tracks issues in Jira via REST API credentials. Copy body below (under the rule) into AGENTS.md's gate 1b section.

---

- Credentials in `.claude/jira.local.json` (gitignored, never committed, never logged, never quoted in output): `baseUrl`, `email`, `apiToken`. Missing/unreadable → stop, ask the user to run through the bootstrap's Jira setup again.
- Search Jira (REST `/rest/api/3/search`) for an open issue with the same goal; read any candidate with `sh .claude/scripts/issue-view.sh <key>`, never a raw REST fetch dumped into context. Reuse + reference its key; never open a second. Else draft, get approval, create via REST `/rest/api/3/issue`.
- Title: plain language a maintainer can scan. Not a slug, ID, or commit subject.
- Self-contained (spec not pushed yet): quote full normative text beside each new ID, each changed requirement as old → new, plus `api-contract.md`/`edge-cases.md` entries. ID with no text is useless.
- Goal + normative changes only. No implementation detail (structure/files/functions/approach) — belongs to gate 2 and PR.
- `##` sections, not prose: `## Background`/`## Why`, `## Scope`, `## Goal`, more as warranted. Compact enumerations, grouped ID ranges. Same shape for PR bodies.
