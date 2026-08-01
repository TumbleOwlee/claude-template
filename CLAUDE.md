# CLAUDE.md

> **This repo is an uninitialized template.** There is no product code yet, and
> nothing here describes a real project.

## If you were asked to initialize, init, or set up this repo

Do **not** write a codebase-summary `CLAUDE.md` — there is no codebase. Run the
bootstrap instead:

**Read [`.claude/skills/project-init/SKILL.md`](./.claude/skills/project-init/SKILL.md)
and follow it end to end.** (Also reachable as `/init-workspace` or
`/project-init`.)

It asks for the project name, purpose, language stack, capability areas, coverage
floor and scope boundaries, then generates `AGENTS.md`, `CLAUDE.md`, `PRD.md`,
`ARCHITECTURE.md`, `CONTRIBUTING.md`, `README.md`, `docs/specs/`, CI and git
hooks from [`templates/`](./templates/) — and deletes itself afterwards.

## What this template is

A spec-driven TDD workflow: `docs/specs/` is authoritative, every behavior change
passes gates (spec diff → tracking issue → implementation plan → implementation →
independent review → PR), implementation runs under strict TDD in an isolated git
worktree, and no agent's self-report counts as verification.

| Path | Purpose |
|---|---|
| `.claude/skills/project-init/` | The bootstrap. Deleted once it has run. |
| `.claude/skills/spec-feature/` | Drives one behavior change through the gates. Kept. |
| `.claude/agents/` | `spec-planner`, `spec-implementer`, `spec-reviewer`. Kept. |
| `templates/` | Source for every generated file. Deleted after the bootstrap. |

Once initialized, this file is replaced by a thin router into `AGENTS.md`.
