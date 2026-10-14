Fills `{{ISSUE_WORKFLOW}}` when project tracks issues on GitHub. Copy body below (under the rule) into AGENTS.workflow.md's `### Tracking issue` section.

---

- Candidates: `gh issue list --state all --search "<goal keywords>"` — numbers only, the orchestrator never reads a body; `spec-author` reads any candidate with `bash .claude/scripts/issue-view.sh <number>`, never raw `gh issue view`. Reuse + reference its number; never open a second.
- File, never retyped: `gh issue create --title "$(head -1 .claude/tasks/artifacts/<slug>/issue-body.md | sed 's/^# //')" --body-file <(tail -n +2 .claude/tasks/artifacts/<slug>/issue-body.md)`. Reuse: `gh issue edit <number>` with the same `--title`/`--body-file`.
- Rewrite after a spec revision or a status-line change: reassemble, then `gh issue edit <number> --body-file <(tail -n +2 .claude/tasks/artifacts/<slug>/issue-body.md)`; a revision also posts `gh issue comment <number> --body-file .claude/tasks/artifacts/<slug>/issue-comment.md`.
- Close: the PR's `Closes #<number>` line (appended by `pr-body.sh`) closes it on merge — nothing to do after merge.
