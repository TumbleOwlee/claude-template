Fills `{{ISSUE_WORKFLOW}}` when project tracks issues in Jira via an MCP server. Copy body below (under the rule) into AGENTS.workflow.md's `### Tracking issue` section.

---

- Candidates: search Jira (MCP search tool) for an open issue with the same goal. A candidate's summary and description come back as tool text — hand exactly that text to `spec-author` for the reuse/new decision, nothing more (MCP tools take and return text, not files: the one place issue content passes through the orchestrator's context). Reuse + reference its key; never open a second.
- File via the MCP create-issue tool: `summary` = line 1 of `.claude/tasks/artifacts/<slug>/issue-body.md` with its `# ` stripped (`sed -n '1s/^# //p'`), `description` = the rest (`tail -n +2`), read only to fill the tool arguments, never retyped. Reuse: the MCP update-issue tool with the same fields.
- Rewrite after a spec revision or a status-line change: reassemble, update the description the same way; a revision also posts `.claude/tasks/artifacts/<slug>/issue-comment.md`'s content through the MCP comment tool.
- Close after merge: the MCP transition tool to the issue's done state; the PR body's `references <key>` line (appended by `pr-body.sh`) links it but closes nothing.
- No Jira MCP tool available in this session → stop, report, ask the user to configure one (`claude mcp list` to check) before continuing.
