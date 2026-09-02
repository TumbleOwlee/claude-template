Fills `{{ISSUE_WORKFLOW}}` when project tracks issues as local files, no external tracker. Copy body below (under the rule) into AGENTS.workflow.md's gate 1b section.

---

- No external tracker — the "issue" is a tracked file, `.claude/issues/<slug>.md`. Search `.claude/issues/` for an open issue with the same goal (no `Closed:`/`Resolved:` marker at top); `spec-author` reads a candidate file directly. Reuse + reference its filename; never create a second.
- File: `cp .claude/tasks/artifacts/<slug>/issue.md .claude/issues/<slug>.md` — line 1 is the title, the rest the body, never retyped.
- Later amendment: append `.claude/tasks/artifacts/<slug>/issue-comment.md` under a `## Update <date>` heading at the end of the file. Never edit above it.
- On merge, prepend `Closed: <PR URL>` to the issue file's first line — keeps it out of the reuse search above without deleting history.
