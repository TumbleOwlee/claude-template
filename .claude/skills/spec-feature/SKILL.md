---
name: spec-feature
description: Drive one behavior change through the repo's gated spec-driven TDD workflow — spec diff, tracking issue, implementation plan, worktree implementation, independent review, PR. Use when starting a feature, fix, or any change to observable behavior in a repo whose AGENTS.md defines these gates.
---

# Spec-driven feature run

Orchestrates one behavior change end to end. `AGENTS.md` is authority; this is
the procedure for running it with worktrees/subagents. Conflict → `AGENTS.md`
wins. Read `AGENTS.md` first.

## Trigger

Behavior change, any size → all gates. Refactor/rename/perf-with-identical-
semantics/tests/docs → no gates, just do it. Size sets stage count, never gate
existence. Test: does this change what the software is required to do?

Check `.claude/tasks/` first. Cards outside `open/`+`done/` = interrupted run
→ *Resume an interrupted run*, don't start fresh.

Task-card content is agent-only: terse fields and log lines, never prose.
Never write explanatory sentences into a card — see card format under gate 2.

## 0. Parent card

`.claude/tasks/open/<slug>.md`. No worktree, no branch — gate 1 is
conversation, nothing on disk yet beyond this card (crash-resume trace).
Create `.claude/tasks/artifacts/<slug>/` alongside it.

## 1. Gate 1 — spec diff. Orchestrator runs this, not an agent.

Abstract, interactive dialog with the user: existing spec + current goal only.
**No implementation code reading** — no grepping how something currently
works, no code-vs-spec check. Dialog outcome decides bug-fix-vs-feature: if
existing spec already covers the ask, no diff — name the requirement instead.

- Surface every silent decision (scope, defaults, naming, in/out), one at a
  time, with a recommendation.
- Read the area's `requirements.md`/`edge-cases.md` yourself (spec-reading,
  fair game).
- Draft the "shall" text + fresh IDs yourself; grep `docs/specs/` for ID
  uniqueness.
- Flag any contradiction with an existing requirement explicitly.

Present, **stop for approval**. On approval: write `artifacts/<slug>/spec-diff.md`,
record `gate1: approved <date>` on parent card + log line. Nothing lands in
`docs/specs/` yet — that's step 4.

## 2. Gate 1b — tracking issue. Orchestrator only; agents never see it.

Search existing issues (open+closed) for the same goal; reuse, never
duplicate. Else draft per `AGENTS.md` — self-contained, full normative text
beside each ID, `##` sections, goal + normative changes only, no impl detail.
**Stop for approval** before creating.

No tracker → goal lives in PR body only. Record `issue: <n>` on parent card.
**`spec-planner`/`spec-implementer` never learn this issue exists** —
orchestrator is sole owner, including later updates from gate 2 findings.

## 3. Gate 2 — implementation plan

Spawn `spec-planner` with a brief: approved spec text, affected area(s),
anything user volunteered at gate 1. Nothing more — gate 1 did no code
research. Never mention the issue.

Returns: stages, numbered file-level steps, dependency tree (deps + files +
terse inline `(file:line)` refs), ID→test table, Verification method, expected
commits. May pause for one concise plan-scoped question — answer, it
continues.

**Spec gap reported instead:** agent stays running, paused. Return to step 1
with the user, scoped to the gap. Resolve, resume the *same* agent (never
respawn) with settled text. Update `spec-diff.md` + issue if changed.

Verify against approved spec + verify the tree itself: independent stages
must not share files; every dependency must actually produce what's consumed.
A wrong tree = a merge conflict three agents later.

Present plan + implied waves ("stages 2,3,4 parallel-capable"), then **ask,
same approval, how to implement**:
- **Sequential** (default) — same `spec-planner` agent continues, no respawn.
- **Parallel** — user names max concurrent agents; fresh `spec-implementer`
  per stage.

Take the number from the user, never infer from the tree. No answer =
sequential.

### On approval — worktree, board, spec landing, in order

```sh
git worktree add .claude/worktrees/<slug> -b <type>/<slug> main
```
First thing to touch disk in the whole run. Gitignored, inside project root
(agent-reachable), one worktree per issue per agent (interleaved commits
otherwise).

- write `artifacts/<slug>/plan.md`; record `gate2` + `mode:
  sequential|parallel(N)` on parent card; move parent → `inprogress/`
- create `open/<slug>.s<n>.md` per stage — `files`/`blocked-by` copied
  verbatim from the tree
- parallel: `open/<slug>.w<n>.md` per wave. sequential: one wave-gate card for
  the whole run
- land approved spec text in the new worktree, normative only — first stage,
  first commit

### Card format (agent-authored, terse only — no prose)

```yaml
---
id: <slug>.s3
parent: <slug>
blocked-by: [<slug>.s2]
files: [src/x.ext, tests/x.ext]
branch: <type>/<slug>-3
worktree: .claude/worktrees/<slug>-3
---
2026-01-02T14:02 spawn agent=impl
2026-01-02T14:05 test-red <ID> rejects_short_input
2026-01-02T14:11 green commit=abc123f
2026-01-02T14:12 gauntlet=pass
```
Append-only log, one line per event, field=value tokens not sentences. A
crash mid-write costs one truncated line, never the file.

## 4. Implement

**Sequential.** Send worktree path + absolute stage-card paths to the *same*
`spec-planner` agent from step 3 — never a new `spec-implementer` spawn. It
reads `spec-implementer.md` itself and follows it stage by stage under TDD on
the feature branch, commits every green stage, moves cards
`open`→`inprogress`→`inreview`. Orchestrator verifies, moves to `done` — no
merge needed, `done` = committed+verified.

**Parallel.** Waves, ≤ approved agent count each:

1. Runnable stages (every `blocked-by` id in `done/`) up to cap. Wave-gate
   card → `inprogress/`.
2. Per stage: `git worktree add .claude/worktrees/<slug>-<n> -b <type>/<slug>-<n> <type>/<slug>`.
3. One fresh `spec-implementer` per worktree — only its own stages, full
   approved spec, plan, own card path. No planner exploration context; this is
   why plan refs must be self-sufficient.
4. Wait for whole wave; cards land in `inreview/`. Per card: merge into
   feature branch, re-run gauntlet on merged result, card → `done/`, remove
   worktree.
5. All done → wave gate `inreview/`: spawn `spec-reviewer` over wave's
   accumulated diff. Clean → wave gate `done/`, next wave auto-starts (no
   approval). Finding → stop, report, implicated stage cards →
   `inprogress/` with finding appended.

Merge conflict inside a wave = tree was wrong. Stop, report, re-plan — never
hand-resolve and continue; tree now lies about everything downstream too.

**An implementer's report is not verification.** Re-run the full gauntlet
yourself (in its worktree if sequential, on merged feature branch per wave if
parallel), read the code described, check ID citations sit beside their
tests, mutation-check any test that looks written after its implementation
(break the impl, confirm the test fails).

Mid-plan stop = plan wrong or spec ambiguous. Resolve with the user; never
"just continue." In a wave, finished branches still merge — only unfinished
stages get re-planned.

## 5. Reconcile the spec

Behavior differing from gate 1 approval = normative, reopens gate 1: show
diff, state what forced it, get approval — same mechanism as step 1, direct
with the user. Editorial fixes (wrong cross-ref, wording) need none. Update
issue if needed. Always report the final spec diff.

## 6. Gate 3 — independent review

Parent card → `inreview/`. Spawn `spec-reviewer` — different agent than
implementer, always, no issue knowledge — with diff base, artifact dir,
worktree path. Appends findings to `artifacts/<slug>/review.md`, keyed to
stage id. Report findings, apply clear fixes, raise decisions; a
stage-reopening finding moves that card → `inprogress/`. Re-run gauntlet after
fixes. **Stop for approval.**

## 7. Gate 4 — pull request

Run plan's Verification method, report outcome, **ask whether to open a PR**
(user may want a manual run first). Confirmed → draft title/body, **stop for
approval of that text**, push, open.

## 8. Merge and clean up

Squash merge to `main` (stage commits, incl. the ahead-of-code spec commit,
never reach `main`). Then:

```sh
git worktree remove .claude/worktrees/<slug>
git worktree list   # nothing under .claude/worktrees/ should remain
```

Per-wave worktrees removed at wave end already; this sweep catches stragglers
from a stopped agent. Parent card → `done/` — no card for this run stays
outside `done/`.

## Resume an interrupted run

Cards outside `open/`+`done/`, no agent running = session died mid-run.
Resume only when the user asks.

No worktree recorded on the card → died during gate 1 dialog or gate 2
planning, nothing on disk to reconcile — resume the conversation from
`spec-diff.md`/`plan.md`'s last state. Past gate 2 → table below.

**Any resumed implementation spawns a fresh agent, never a continuation** —
the `spec-planner` continuation only lives inside a live orchestrator session,
does not survive a crash. This is why plan refs must be lossless: a fresh
implementer resuming mid-plan gets nothing but what the plan wrote down.

**Reconcile every card against git before acting.** Card = intent, git =
fact:

| Card claims | Check | Disagreement means |
|---|---|---|
| worktree | `git worktree list` | card stale |
| branch | `git rev-parse` | stage never started |
| `commit=<sha>` | sha exists, on that branch | commit never landed |
| `gauntlet=pass` | re-run at that sha | card overstated state |
| stage `done` | `git branch --contains` vs feature branch | never merged; downstream plans a lie |

Report differences first. Agree → resume. Disagree → stop: card behind git is
a forgotten move, correctable; card claiming what git can't show is never
trusted.

Clean reconcile → resume only no-approval work (respawn implementers for
approved stages, merge finished branches, run wave gates); halt at first gate
needing the user. `gate1`/`gate2` approvals on the parent card stay valid, no
re-ask.

## Standing rules

- Never commit to `main`.
- Never a tool attribution trailer (`Co-Authored-By`, "Generated with") in
  commit/PR/issue/comment.
- Never skip a gate for size.
- Never treat an agent's self-report as verification.
- Never exceed the approved agent count, never parallelize when gate 2 said
  sequential.
- Never two concurrent agents sharing a worktree or file.
- Never move a card to `done/` for work you did yourself — orchestrator-only,
  post-merge-and-gauntlet.
- Never act on a card git contradicts.
- Never fold an unrelated pre-existing spec/code disagreement in — raise
  separately.
- Never spawn `spec-planner` for gate 1 — orchestrator authors spec text
  directly, no drift through a second party.
- Never mention issue/PR/tracker to `spec-planner` or `spec-implementer`.
- Never create the worktree before gate 2 approval.
