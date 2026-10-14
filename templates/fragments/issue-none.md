Fills `{{ISSUE_WORKFLOW}}` when project has no issue tracker. Copy body below (under the rule) into AGENTS.workflow.md's `### Tracking issue` section.

---

- No issue tracker → nothing is filed, but the goal is still written down and approved: `spec-author` drafts `issue.md`, the assembled `issue-body.md` stays in `artifacts/<slug>/`; record `issue: artifacts/<slug>/issue-body.md` on the parent card (`pr-body.sh` appends no closing line for a path).
- Rewrite after a spec revision or a status-line change: reassemble `issue-body.md` in place; a revision also appends `issue-comment.md` under a `## Changelog` heading at its end.
- At gate 4, `pr-body.sh full` carries the status line and `pr.md` only; `spec-author` folds `issue-body.md`'s `## Spec` list into `pr.md`'s `## Changes` so merged history records what was asked for and what was built.
- Close: nothing — *After merge* removes `artifacts/<slug>/` and the record lives in the PR.
