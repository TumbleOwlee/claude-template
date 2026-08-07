# Repository Template

A GitHub template repository for projects built with a **spec-driven TDD workflow**: an authoritative specification, gated behavior changes, strict test-first implementation in isolated worktrees, and an independent review before every PR.

Fork it, run one command, and the workflow is set up for your language and your project.

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
- language stack — **Rust**, **Python**, **Node/TypeScript**, **Go**, or **C/C++ with CMake** (Make or Ninja) — detected from a manifest where one exists
- the exact build / test / lint / coverage commands, for confirmation
- capability areas and their requirement-ID prefixes (`FR-R-nnn`, `CL-R-nnn`, …)
- the coverage floor, this project's scope boundaries, and the issue tracker — GitHub (`gh`), Jira (MCP server or REST credentials), local files, or none

and then writes:

| File | What it is |
|---|---|
| `AGENTS.md` | The workflow and conventions. The file agents read first. |
| `CLAUDE.md` | Thin router into `AGENTS.md`. |
| `.github/copilot-instructions.md` | Same router, for GitHub Copilot. |
| `PRD.md` | Why the project exists — goals, non-goals, users. |
| `ARCHITECTURE.md` | Module map, data flow, concurrency, testing seams. |
| `CONTRIBUTING.md` | The human-facing version of the same rules. |
| `docs/specs/` | The authoritative specification, one directory per area. |
| `.github/workflows/check.yml` or `bitbucket-pipelines.yml` | fmt / lint / types / test / coverage gates — whichever matches the detected remote host. |
| `.lefthook.yml` | Pre-commit checks, plus spec and requirement-ID reminders. |
| `.claude/scripts/extract-section.sh` | Prints one markdown section by heading — reads a slice of a spec file instead of the whole thing. |
| `.claude/scripts/list-sections.sh` | Lists a markdown file's headings verbatim, so an agent knows what `extract-section.sh` can pull without grepping first. |
| `.claude/scripts/token-rank.sh` | Ranks given files by rough token cost of a full Read (`chars/4`), highest first. |
| `.claude/scripts/failed-workflow.sh` | Prints the error output of the most recent failed CI run on a branch — GitHub Actions or Bitbucket Pipelines, auto-detected. |
| `.claude/scripts/issue-view.sh` | Prints an issue's title, body, and comments in compact plain text — Jira or GitHub, auto-detected. |

`failed-workflow.sh` and `issue-view.sh`: if a script's output isn't enough (multiple failed jobs, huge issue thread, unexpected API error), never fall back to raw `gh`/`git`/`curl` commands to fill the gap — stop and report the shortfall to the user.

Finally it deletes `templates/` and its own skill, so the fork looks like a normal project.

## The workflow it sets up

`docs/specs/` is normative — code conforms to the spec, not the reverse. Every change to observable behavior passes 4 gates (spec diff → tracking issue → implementation plan → PR), implemented stage by stage under TDD in an isolated git worktree, independently reviewed before merge. Full gate text: generated `AGENTS.md` (source: `templates/AGENTS.md.tmpl`).

State lives on an on-disk task board (`.claude/tasks/`) so an interrupted session resumes instead of restarting.

Running one change through it: `/spec-feature`. Product-owner-only slice — requirement → spec via conversation → tracking issue, stop: `/spec-request`. Independent second-developer review of a finished PR against its ticket, standalone from the implementing session: `/spec-review`.

## What ships

```
.claude/skills/project-init/     the bootstrap (self-deleting)
.claude/skills/init-workspace/   alias, avoids the built-in /init
.claude/skills/spec-feature/     drives one change through the gates
.claude/skills/spec-request/     PO-only slice: requirement -> spec -> ticket, stop
.claude/skills/spec-review/      standalone reviewer: ticket + PR -> review, stop
.claude/skills/context-audit/    finds what's re-read a lot, suggests scripts to cut it
.claude/skills/agent-doc-audit/  checks agent docs for bloat and split-worthy sections
.claude/agents/                  spec-planner, spec-implementer, spec-reviewer
.claude/tasks/                   task board, empty until the first run
.claude/settings.json            SessionStart hook: flags an interrupted run
templates/                       every generated file, plus one file per stack
```

## Requirements

- [Claude Code](https://claude.com/claude-code)
- `git` 2.5+ (worktrees), and `gh` (GitHub) or a Jira MCP server / API token if you want the tracking-issue gate backed by a tracker
- Optionally [lefthook](https://github.com/evilmartians/lefthook) for the pre-commit checks
- Optionally the caveman plugin for compressed agent output — install command offered by the bootstrap itself (`project-init` step 0)
