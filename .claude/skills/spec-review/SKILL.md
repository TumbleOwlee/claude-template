---
name: spec-review
description: Independent second-developer review of an open PR against its ticket's spec — standalone entrypoint, no shared session with whoever implemented it. Input is the ticket (holds the approved spec plus any updates landed during implementation). Output is the full gate-3-style review for the developer's own approval gate before manual QA and merge. Use when a different developer needs to review a finished branch/PR before it merges.
---

# Spec review (independent, PR-facing)

**Concise, compact, facts only.**

`AGENTS.workflow.md`'s `### Gate 3` defines what a review checks (spec fidelity, standards, TDD honesty, docs currency) and how (`spec-reviewer` agent, never the implementer). This skill supplies gate 3's *inputs* for a reviewer outside the implementing session; it restates no criteria. Conflict → `AGENTS.workflow.md` wins.

## Gather inputs — no shared session, no artifacts dir

- **Ticket** — `sh .claude/scripts/extract-section.sh '### Gate 1b — tracking issue. Stop for approval.' AGENTS.workflow.md` names the tracker and how to read it. Ticket is self-contained: full current normative text, including updates landed via "Reconcile the spec". This *is* the approved spec — `artifacts/<slug>/spec-diff.md` may not exist on this machine or may be gone.
- **Branch/PR** — from the ticket's linked PR, or ask the user for PR number/branch. Read the PR with `bash .claude/scripts/pr-view.sh <number>`, never raw `gh pr view`.
- **Base ref** — PR's target branch (usually `main`).

## Run the review

Write the ticket's normative text into a scratch `artifacts/<slug>/spec-diff.md` (one `## <ID>` per requirement, same shape as gate 1) so the reviewer reads it the way it reads every spec diff. Spawn `spec-reviewer` (`.claude/agents/spec-reviewer.md`) with: scope `branch` (not a wave), the base ref, the artifact dir, the checkout path, every stage in scope. No `plan.md` exists on this side — say so; spec fidelity is checked against `spec-diff.md` alone. It reads its own rules (`.claude/AGENTS.core.md`); give it nothing more, never the issue/PR number.

Give it a scratch `artifacts/<slug>/` for `review.md` and `review.verdict.md`; it answers with a status line only (`### Agent hand-off`). The requirement is a reader that never held the implementer's context: a fresh session may review inline with the same axes and rigor; a session that implemented any of it spawns.

## Output

`review.md`: axis-grouped, severity-tagged, no praise. `review.verdict.md`: open findings only, capped. Point the developer at the verdict (`sh .claude/scripts/show-file.sh`), the full file on request; findings needing a user decision are flagged, not resolved.

## Stop condition

Report and stop. Approving is the developer's own gate before manual QA and merge — no PR edits, no merge, no board.
