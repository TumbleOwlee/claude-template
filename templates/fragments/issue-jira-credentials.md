Fills `{{ISSUE_WORKFLOW}}` when project tracks issues in Jira via REST API credentials. Copy body below (under the rule) into AGENTS.workflow.md's `### Tracking issue` section.

---

- Credentials in `.claude/jira.local.json` (gitignored, never committed, never logged, never quoted in output): `baseUrl`, `email`, `apiToken`. Missing/unreadable → stop, ask the user to run through the bootstrap's Jira setup again.
- Candidates: search Jira (REST `/rest/api/3/search`) for an open issue with the same goal, keys only; `spec-author` reads any candidate with `bash .claude/scripts/issue-view.sh <key>`, never a raw REST fetch dumped into context. Reuse + reference its key; never open a second.
- File via REST `/rest/api/3/issue`: `summary` = line 1 of `.claude/tasks/artifacts/<slug>/issue-body.md` with its `# ` stripped, `description` = the rest, both read from the file into the JSON payload (`jq -Rs`), never retyped. Reuse: `PUT /rest/api/3/issue/<key>` with the same fields.
- Rewrite after a spec revision or a status-line change: reassemble, `PUT /rest/api/3/issue/<key>` with the new `description`; a revision also posts `POST /rest/api/3/issue/<key>/comment` with `.claude/tasks/artifacts/<slug>/issue-comment.md`'s content the same way.
- Close after merge: transition the issue to its done state (`POST /rest/api/3/issue/<key>/transitions`); the PR body's `references <key>` line (appended by `pr-body.sh`) links it but closes nothing.
