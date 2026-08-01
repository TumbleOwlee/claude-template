---
name: spec-feature
description: Drive one behavior change through the repo's gated spec-driven TDD workflow — spec diff, tracking issue, implementation plan, worktree implementation, independent review, PR. Use when starting a feature, fix, or any change to observable behavior in a repo whose AGENTS.md defines these gates.
---

# Spec-driven feature run

Orchestrates one behavior change end to end. `AGENTS.md` is the authority — this
skill is the procedure for running it with worktrees and subagents. Where the two
disagree, `AGENTS.md` wins.

Read `AGENTS.md` before anything else.

## Does this even trigger?

Behavior change of any size → all gates. Refactor, rename, perf work with
identical semantics, tests, docs → no gates, just do the work. Size sets the
number of stages, never whether the gates exist. If unsure, ask: *does this
change what the software is required to do?*

## 0. Branch and worktree

```sh
git worktree add ../<repo>-<slug> -b <type>/<slug> main
```

One worktree per issue, per agent. Two agents in one checkout interleave commits.
Everything below happens in that worktree.

## 1. Gate 1 — spec diff

Spawn `spec-planner` with: the ask, the affected area(s), and the worktree path.

It returns the normative text. **You verify before showing it to the user:**

- Quoted requirement text matches the file on disk.
- Appended IDs are genuinely unused — grep all of `docs/specs/`.
- Nothing contradicts an existing requirement or `edge-cases.md` entry.
- It proposes what was actually asked, no more.

Then present it and **stop for approval**.

## 2. Gate 1b — tracking issue

Search existing issues (open and closed) for the same goal. Reuse what exists;
never open a second. Otherwise draft the issue per `AGENTS.md` — self-contained,
full normative text beside every ID, `##` sections, goal and normative changes
only, no implementation detail — and **stop for approval** before creating it.

Skip entirely if the repo has no tracker; the goal then lives in the PR body.

## 3. Write the spec

Land the approved text in the working tree. Normative text only — nothing marked
unfinished. This is the first stage and the first commit.

## 4. Gate 2 — implementation plan

Spawn `spec-planner` again with the approved spec. It returns stages, file-level
steps, the ID → test table, the Verification method, expected commits. Verify it
against the approved spec, then **stop for approval**.

## 5. Implement

Spawn `spec-implementer` with the approved spec, the approved plan, and the
worktree path. It works stage by stage under TDD and commits every green stage.

When it reports back: **its report is not verification.** In its worktree, re-run
the full gauntlet from `AGENTS.md` yourself, read the code it describes, check
that ID citations sit beside their tests, and mutation-check any test that looks
like it was written after its implementation — break the implementation, confirm
the test fails.

If it stopped mid-plan, that is the plan being wrong or the spec being ambiguous.
Resolve it with the user; do not tell the agent to "just continue".

## 6. Reconcile the spec

Behavior that ended up differing from what gate 1 approved is normative and
re-opens gate 1: show the diff, state what forced it, get approval. Editorial
fixes (a wrong cross-reference, clumsy wording) need no approval. Report the
final spec diff either way.

## 7. Gate 3 — independent review

Spawn `spec-reviewer` — a different agent than the implementer, always — with the
diff base, the approved spec text, and the worktree path. Report its findings,
apply the fixes that are clearly fixes, and raise the ones that are decisions.
Re-run the gauntlet after any fix. **Stop for approval.**

## 8. Gate 4 — pull request

Run the plan's Verification method, report the outcome, then **ask whether to open
a PR** — the user may want their own manual run first. Once confirmed, draft title
and body, **stop for approval of that text**, then push and open it.

## 9. Merge and clean up

Squash merge to `main`, so the stage commits — including the spec commit that ran
ahead of its code — never reach `main`. Then:

```sh
git worktree remove ../<repo>-<slug>
```

## Standing rules

- Never commit to `main`.
- Never skip a gate because the change is small.
- Never let an agent's self-report stand as verification.
- Never fold an unrelated pre-existing spec/code disagreement into this work.
  Raise it as its own task.
