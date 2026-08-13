Fills `{{ISSUE_WORKFLOW}}` when project tracks issues in Jira via an MCP server. Copy body below (under the rule) into AGENTS.md's gate 1b section.

---

- Search Jira (MCP search tool) for an open issue with the same goal. Reuse + reference its key; never open a second. Else draft, get approval, create via the MCP create-issue tool.
- Title: plain language a maintainer can scan. Not a slug, ID, or commit subject.
- Self-contained (spec not pushed yet): quote full normative text beside each new ID, each changed requirement as old → new, plus `api-contract.md`/`edge-cases.md` entries. ID with no text is useless.
- Goal + normative changes only. No implementation detail (structure/files/functions/approach) — belongs to gate 2 and PR.
- `##` sections, not prose: `## Background`/`## Why`, `## Scope`, `## Goal`, more as warranted. Compact enumerations, grouped ID ranges. Same shape for PR bodies.
- Never edit the issue after filing — append updates via the MCP comment tool.
- No Jira MCP tool available in this session → stop, report, ask the user to configure one (`claude mcp list` to check) before continuing gate 1b.
