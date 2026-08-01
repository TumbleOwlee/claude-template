# Repository Template

A GitHub template repository for projects built with a **spec-driven TDD
workflow**: an authoritative specification, gated behavior changes, strict
test-first implementation in isolated worktrees, and an independent review before
every PR.

Fork it, run one command, and the workflow is set up for your language and your
project.

## Use it

```sh
gh repo create my-project --template <you>/repo-template --private --clone
cd my-project
claude
```

Then, in Claude Code:

```
/init
```

If the built-in `/init` answers instead of the bootstrap, use `/init-workspace`.

The bootstrap asks for:

- project name, one-line description, and kind (library / binary / service / CLI / TUI)
- language stack — **Rust**, **Python**, **Node/TypeScript**, **Go**, or
  **C/C++ with CMake** (Make or Ninja) — detected from a manifest where one exists
- the exact build / test / lint / coverage commands, for confirmation
- capability areas and their requirement-ID prefixes (`FR-R-nnn`, `CL-R-nnn`, …)
- the coverage floor, the issue tracker, and this project's scope boundaries

and then writes:

| File | What it is |
|---|---|
| `AGENTS.md` | The workflow and conventions. The file agents read first. |
| `CLAUDE.md` | Thin router into `AGENTS.md`. |
| `PRD.md` | Why the project exists — goals, non-goals, users. |
| `ARCHITECTURE.md` | Module map, data flow, concurrency, testing seams. |
| `CONTRIBUTING.md` | The human-facing version of the same rules. |
| `docs/specs/` | The authoritative specification, one directory per area. |
| `.github/workflows/check.yml` | fmt / lint / types / test / coverage gates. |
| `.lefthook.yml` | Pre-commit checks, plus spec and requirement-ID reminders. |

Finally it deletes `templates/` and its own skill, so the fork looks like a normal
project.

## The workflow it sets up

`docs/specs/` is normative — code conforms to the spec, not the reverse. Every
change to observable behavior passes gates, whatever its size:

1. **Gate 1 — spec diff.** The actual "shall" text with appended IDs, approved
   before any code.
2. **Gate 1b — tracking issue.** Self-contained, goal only, no implementation
   detail.
3. **Gate 2 — implementation plan.** Stages, an ID → test table, a named
   verification method.
4. **Implement** stage by stage under TDD, in a dedicated git worktree, committing
   every green checkpoint.
5. **Gate 3 — independent review** by an agent that did not write the code: spec
   fidelity, standards, TDD honesty.
6. **Gate 4 — pull request**, squash-merged so `main` never carries a spec ahead
   of its code.

Running one change through it: `/spec-feature`.

## What ships

```
.claude/skills/project-init/   the bootstrap (self-deleting)
.claude/skills/init-workspace/ alias, avoids the built-in /init
.claude/skills/spec-feature/   drives one change through the gates
.claude/agents/                spec-planner, spec-implementer, spec-reviewer
templates/                     every generated file, plus one file per stack
```

## Requirements

- [Claude Code](https://claude.com/claude-code)
- `git` 2.5+ (worktrees), and `gh` if you want the tracking-issue gate
- Optionally [lefthook](https://github.com/evilmartians/lefthook) for the
  pre-commit checks
- Optionally the caveman plugin for compressed agent output:
  ```sh
  claude plugin marketplace add JuliusBrussee/caveman
  claude plugin install caveman@caveman
  ```
