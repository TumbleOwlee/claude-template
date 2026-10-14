Fills `{{ISSUE_WORKFLOW}}` when project tracks issues as local files, no external tracker. Copy body below (under the rule) into AGENTS.workflow.md's `### Tracking issue` section.

---

- No external tracker — the "issue" is a tracked file, `.claude/issues/<slug>.md`; `issue` on the parent card is that path. Candidates: `grep -L '^Closed:' .claude/issues/*.md` filtered by goal keywords, filenames only — the orchestrator never reads a body; `spec-author` reads each with `sh .claude/scripts/extract-section.sh '## Goal' <file>`. Reuse + reference its filename; never create a second.
- File, never retyped: `cp .claude/tasks/artifacts/<slug>/issue-body.md .claude/issues/<slug>.md` — line 1 is `# <title>`, the rest the body. Reuse: `issue-request.sh` does not read files — copy the old file's body into `artifacts/<slug>/request.md` yourself before the first rewrite. Commit it with the branch's squash, not on `main`.
- Rewrite after a spec revision or a status-line change: reassemble and `cp` over the file again; a revision also appends `.claude/tasks/artifacts/<slug>/issue-comment.md` under a `## Changelog` heading at the end of the file (the body above is the current spec, the changelog below its history).
- Close after merge: prepend `Closed: <PR URL>` as the file's first line — keeps it out of the reuse search above without deleting history. `pr-body.sh` appends no closing line for a path.
