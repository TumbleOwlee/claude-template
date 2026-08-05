# CLAUDE.md

> Uninitialized template. No product code, no real project described here.

## Asked to init/set up this repo?

Do not write a codebase-summary CLAUDE.md — no codebase exists. Read
[`.claude/skills/project-init/SKILL.md`](./.claude/skills/project-init/SKILL.md)
and follow it end to end (also `/init-workspace`, `/project-init`).

Asks: project name, purpose, stack, capability areas, coverage floor, scope
boundaries. Generates `AGENTS.md`, `CLAUDE.md`, `PRD.md`, `ARCHITECTURE.md`,
`CONTRIBUTING.md`, `README.md`, `docs/specs/`, CI, git hooks from
[`templates/`](./templates/). Deletes itself after.

## What this is

Spec-driven TDD: `docs/specs/` authoritative. Gates: spec diff → tracking
issue → implementation plan → implementation → independent review → PR.
Implementation = strict TDD, isolated git worktree. No agent self-report
counts as verification.

| Path | Purpose |
|---|---|
| `.claude/skills/project-init/` | Bootstrap. Deleted after run. |
| `.claude/skills/spec-feature/` | Drives one behavior change through gates. Kept. |
| `.claude/agents/` | `spec-planner`, `spec-implementer`, `spec-reviewer`. Kept. |
| `templates/` | Source for generated files. Deleted after bootstrap. |

Post-init: this file becomes a thin router into `AGENTS.md`.
