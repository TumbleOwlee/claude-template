Fills `{{ISSUE_WORKFLOW}}` when project has no issue tracker. Copy body below (under the rule) into AGENTS.workflow.md's `### Tracking issue` section.

---

- No issue tracker → nothing is filed, but the goal is still written down and approved: `spec-author` drafts `issue.md`, the assembled `issue-body.md` stays in `artifacts/<slug>/`; record `issue: artifacts/<slug>/issue-body.md` on the parent card (`pr-body.sh` appends no closing line for a path).
- Status line (gate 2 approval, a split filed, CI green — never a body rewrite): `sh .claude/scripts/issue-body.sh <slug> --status <(tail -n +2 .claude/tasks/artifacts/<slug>/issue-body.md) > .claude/tasks/artifacts/<slug>/issue-status.md`, then `{ head -1 .claude/tasks/artifacts/<slug>/issue-body.md; cat .claude/tasks/artifacts/<slug>/issue-status.md; } > .claude/tasks/artifacts/<slug>/issue-file.md && mv .claude/tasks/artifacts/<slug>/issue-file.md .claude/tasks/artifacts/<slug>/issue-body.md`. Comment (a kept spec change): append `issue-comment.md` under a `## Changelog` heading at its end. A slice, split or follow-up issue is its `slice-<n>.md`/`split-issue.md`/`follow-up-<k>.md` kept in `artifacts/<slug>/`, its path the reference; open titles for `spec-author`'s follow-up dedupe: none.
- At gate 4 the full PR body already carries the requirements and scenarios (`pr-body.sh full`), so merged history records what was asked for and what was built without the issue.
- Close: nothing — *Clean up* removes `artifacts/<slug>/` and the record lives in the PR.
