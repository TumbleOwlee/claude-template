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
| `AGENTS.md` | Spec-driven rules, TDD order, build commands, conventions, scope boundaries. The file agents read first. |
| `AGENTS.workflow.md` | The gates (brief, architecture, plan, review, PR), lanes, epics, task board, approval prompt, stage-by-stage implementation, spec changes, clean up, resume. Orchestrator-only, pulled one heading at a time. |
| `.github/PULL_REQUEST_TEMPLATE.md` | Why / Changes / Tests / Verification beyond the gauntlet / Decisions — the gate 4 PR body's sections (GitHub remotes only). |
| `CLAUDE.md` | Thin router into `AGENTS.md`. |
| `.github/copilot-instructions.md` | Same router, for GitHub Copilot. |
| `PRD.md` | Why the project exists — goals, non-goals, users. |
| `ARCHITECTURE.md` | Module map, data flow, concurrency, testing seams. |
| `CONTRIBUTING.md` | The human-facing version of the same rules. |
| `docs/specs/` | The authoritative specification, one directory per area. |
| `.github/workflows/check.yml` or `bitbucket-pipelines.yml` | fmt / lint / types / test / coverage gates — whichever matches the detected remote host. |
| `.lefthook.yml` | Pre-commit checks, plus spec and requirement-ID reminders. |
| `.claude/scripts/extract-section.sh` | Prints one or more markdown sections by heading (`--prefix`: the first heading starting with the text, so a stage is found by its id whatever its title) — reads a slice of a spec file instead of the whole thing. |
| `.claude/scripts/extract-id.sh` | Finds one or more spec entries (`-R-` requirements, `-E-` edge cases) by ID, prints `file:line:text` each — exact spot to edit, no guessing which file it's in. |
| `.claude/scripts/list-sections.sh` | Lists a markdown file's headings verbatim, so an agent knows what `extract-section.sh` can pull without grepping first. |
| `.claude/scripts/token-rank.sh` | Ranks given files by rough token cost of a full Read (`chars/4`), highest first. |
| `.claude/scripts/failed-workflow.sh` | Prints the error output of the most recent failed CI run on a branch — GitHub Actions or Bitbucket Pipelines, auto-detected. |
| `.claude/scripts/issue-view.sh` | Prints an issue's title, body, and comments in compact plain text — Jira or GitHub, auto-detected. |
| `.claude/scripts/pr-view.sh` | Prints a PR's title, body, and comments in compact plain text — GitHub or Bitbucket, auto-detected. Sidesteps a `gh pr view` GraphQL bug (legacy Projects-Classic boards) that errors on the raw command with or without `--comments`. |
| `.claude/scripts/pr-feedback.sh` | `fetch` writes a PR's unresolved inline review threads to a file and prints one status line; `reply` posts the implementer's `reply: fixed` / `reply: declined` blocks back on each thread, resolving the fixed ones — GitHub or Bitbucket, auto-detected. The bridge between the draft PR (where the user reviews) and the workflow. |
| `.claude/scripts/card-field.sh` | Reads one frontmatter field, the last log value of a key, or the last green sha from a run's parent card, wherever on the board it sits. |
| `.claude/scripts/issue-body.sh` | Assembles the tracking issue's body — what the user gets, never how it is built: a status line read from the board, the goal, requirements and scenarios under local IDs, out of scope, the original request. Written once at filing; `--status <live body>` rewrites only its status line afterwards. `--slice <n>` assembles one slice's child issue of an epic. Refuses (exit 3) a body whose visible text names a stage id or an agent. |
| `.claude/scripts/spec-render.sh` | Renders one part of a run's `spec-diff.md` (scenarios, requirements, the entry table with its issue-ID column, dated spec changes, deferred points) — the piece `issue-body.sh` and `pr-body.sh` share. |
| `.claude/scripts/card-log.sh` | The only writer of task-card log lines: finds the card wherever the board moved it, stamps UTC, validates the event against the vocabulary table in the script (scope, keys, values, ≤ 160 characters) and rejects anything else — `hook-guard-shell.sh` denies a raw append onto a card. |
| `.claude/scripts/related-ids.sh` | Spec entries across every area that mention a keyword, so a new entry cites or reconciles with them instead of duplicating one. |
| `.claude/scripts/metrics.sh` | Appends one line per finished run to a never-cleaned `metrics.log` — start, end, first failing test, stages, stops by kind, re-plans, lane — so a workflow change can be measured. |
| `.claude/scripts/run-rebuild.sh` | Recreates a lost task board from the tracking issue, the draft PR and git, so an interrupted run resumes through the usual reconcile and a re-plan from its next open stage. |
| `.claude/scripts/id-collisions.sh` | Gate 4 check: fixed spec IDs the branch defines that the target branch now defines too (two runs took the same next free ID) — prints `ids=clean` or `ids=collide <IDs>`. |
| `.claude/scripts/run-cleanup.sh` | The run's last step once the PR is ready and CI is green: removes the worktree and its local branch, archives the run's cards and artifacts under `.claude/tasks/archive/<slug>/`; refuses while the worktree holds uncommitted or unpushed work. |
| `.claude/scripts/tests/run.sh` | Golden and assertion tests for every script above that needs no `gh` (body assemblers, prompt lines, card reader and writer, metrics, rebuild, hook guards, the gauntlet cache, clean-up, ID collisions) against a fixture board, plus a check that the card vocabulary covers every event the docs name; `UPDATE=1` rewrites the goldens. Runs in the generated CI. |
| `.claude/scripts/issue-request.sh` | Prints an issue's original request, unwrapping a body this workflow assembled earlier, for `artifacts/<slug>/request.md`; `--spec` extracts a ticket's approved brief, `--epic`/`--slice-line`/`--comments` serve a slice run. |
| `.claude/scripts/pr-body.sh` | Renders the PR body — the how, where the issue holds the what. `draft` on every card move: status line, why, scenarios, one checklist line per stage with its verification, review hints, then the sections both forms share (requirements with their issue IDs, spec changes since filing read live from the cards, the architecture component table, decisions). `full` at gate 4: the same minus the board, with `pr.md`'s prose. Refuses a stage card found in two state directories and a body whose visible text names a stage id or an agent. Appends `Closes #n` or `references KEY` from the parent card's issue reference. |
| `.claude/scripts/prompt-lines.sh` | Prints the lines of an approval file the orchestrator may quote in its approval prompt (goal, scenarios, entry and deferred counts, architecture and interfaces, slices, decide line, stops, verdict with its `Not checked` line, follow-up titles, confirmations including every `[spec <ID>]` decision — `PROMPT_SINCE_REV` limits those to the newest revision) — the fixed-shape prompt is built from these alone, never from a paraphrase. |
| `.claude/scripts/hook-guard-shell.sh` | `PreToolUse` hook, wired in `.claude/settings.json`: denies an unpiped `cat` of a markdown/large file, an unscoped `git show`/`git diff`, an unscoped `find -type f/d`, a raw `gh issue view`, a raw `gh pr view`, a `git commit` while on `main`, a `git push` targeting `main` (following `git -C <dir>` and a preceding `cd`), or a raw append onto a task card — enforces `AGENTS.md`'s shell-output and branch-safety rules instead of just stating them. |
| `.claude/scripts/hook-guard-attribution.sh` | `PreToolUse` hook, wired alongside: denies a `git commit` / `gh pr create|edit|comment` / `gh issue create|comment` whose text or `--body-file` carries a `Co-Authored-By` / "Generated with" trailer — the trailer form only, prose that mentions the words passes. |
| `.claude/scripts/hook-guard-readonly.sh` | `PreToolUse` hook on the `spec-reviewer` agent only (its frontmatter): denies every command that could alter the repo, the worktree, or the filesystem — the reviewer's only sanctioned writes are `review.md` (append) and `review.verdict.md` (rewrite). |
| `.claude/scripts/show-file.sh` | Opens the files of one approval stop for the user in a viewer outside the agent's context (tmux + glow, wslview, tmux + less, else a manual hint; `SHOW_FILE_VIEWER` overrides it with a command or `none`), lists them in `artifacts/<slug>/approval`, a marker an editor can watch, and prints each file's `prompt-lines.sh` output; refuses a `*.summary.md` / `*.verdict.md` over 25 lines / 2 KB so agents keep user-facing summaries short. |
| `.claude/scripts/gauntlet.sh` | Runs the full build/test/lint/coverage block with per-step timeouts, logs everything to `artifacts/<slug>/gauntlet.log`, prints one `gauntlet=pass cov=… sha=…` / `gauntlet=fail step=…` line — the only verification output the orchestrator ever holds in context. A pass is cached by the worktree's tree, so pushing an already verified tree answers `cached` at once (`GAUNTLET_FORCE=1` reruns). |

`failed-workflow.sh`, `issue-view.sh`, `pr-view.sh`, `pr-feedback.sh` are bash scripts (`bash .claude/scripts/…`, not `sh` — they use `pipefail`). If a script's output isn't enough (multiple failed jobs, huge issue thread, unexpected API error), never fall back to raw `gh`/`git`/`curl` commands to fill the gap — stop and report the shortfall to the user.

Finally it deletes `templates/` and its own skill, so the fork looks like a normal project.

## The workflow it sets up

`docs/specs/` is normative — code conforms to the spec, not the reverse. Every change to observable behavior passes 4 gates (brief → architecture → implementation plan with its tracking issue → whole-branch review → PR), implemented stage by stage under TDD in an isolated git worktree. Gate 1 is a best-effort brief: scenarios and entries under local IDs, with open points deferred to the agent that settles them; a `spec-architect` reads the code and settles the structure (components, interface sketches, a verbatim code map); the planner refines the entries and assigns their fixed IDs; after the spec lands, the implementer edits it inside the stage commit and a reviewer classifies each change as detail or meaningful (keep, revert or split — the user's call). A feature too big for one run becomes an epic: a skeleton architecture and one child issue per slice. Each run picks a lane at its first stop: **full** reviews every stage with a fresh reviewer and stops only when a stop rule fires (otherwise it auto-continues with a one-line notice); **fast** approves brief and architecture at one stop, commits each stage on green, reviews the branch once and stops only at gate 4. The tracking issue states what the user gets (goal, requirements, scenarios) and afterwards only its status line changes; the PR states how it was built. The first push opens a draft PR whose body is rendered from the task board on every move — stages, requirements, the spec changes committed so far, architecture and decisions — so the user reviews as stages land; an implementer that hits an open decision asks through the same question batch as every other agent, and a plan that stops fitting is re-planned from the next uncommitted stage instead of halting the run; inline PR comments come back into the run through `pr-feedback.sh`, gate 4 marks that same PR ready, files the follow-ups the run noticed outside its goal, waits for CI, records the run's metrics and archives the board — the human merges. The orchestrating session never drafts, reads, or pastes content: `spec-author`, `spec-architect`, `spec-planner`, `spec-implementer` and `spec-reviewer` write files under `.claude/tasks/artifacts/<slug>/` and answer with one status line; every approval prompt has one fixed shape built by `prompt-lines.sh` from the capped files the user opens outside the context. Full gate text: generated `AGENTS.workflow.md` (source: `templates/AGENTS.workflow.md.tmpl`).

State lives on an on-disk task board (`.claude/tasks/`) so an interrupted session resumes instead of restarting.

Running one change through it: `/spec-feature`. Product-owner-only slice — requirement → brief via conversation → tracking issue, stop: `/spec-request`. Independent second-developer review of a finished PR against its ticket, standalone from the implementing session: `/spec-review`.

## What ships

```
.claude/skills/project-init/     the bootstrap (self-deleting)
.claude/skills/init-workspace/   alias, avoids the built-in /init
.claude/skills/spec-feature/     drives one change through the gates
.claude/skills/spec-request/     PO-only slice: requirement -> spec -> ticket, stop
.claude/skills/spec-review/      standalone reviewer: ticket + PR -> review, stop
.claude/skills/context-audit/    finds what's re-read a lot, suggests scripts to cut it
.claude/skills/agent-doc-audit/  checks agent docs for bloat and split-worthy sections
.claude/agents/                  spec-author, spec-architect, spec-planner, spec-implementer, spec-reviewer
.claude/agent-parts/             the agents' rarely read sections (split issue, gate 4 sync, epics)
.claude/tasks/                   task board, empty until the first run
.claude/settings.json            SessionStart hook: flags an interrupted run; PreToolUse hooks: enforce the shell-output Conventions and the no-attribution-trailer rule
templates/                       every generated file, plus one file per stack
```

## Maintaining this template

Descendant projects run the workflow for real and sometimes improve on it — a sharper agent rule, a fixed script, a Merge-step fix nobody thought of at bootstrap time. `.claude/skills/template-harvest/` (this repo only, self-deleting like `project-init`) points at one or more descendant paths and reports what's worth backporting here, without touching either side — you apply findings by hand.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- `git` 2.5+ (worktrees), `jq` (hooks), `timeout` (coreutils, for `gauntlet.sh`), and `gh` (GitHub) or a Jira MCP server / API token if you want the tracking-issue gate backed by a tracker
- Optionally [lefthook](https://github.com/evilmartians/lefthook) for the pre-commit checks
- Optionally `tmux` + [glow](https://github.com/charmbracelet/glow) (or `wslview` on WSL) so approval files open in a viewer instead of being printed
- Optionally the caveman plugin for compressed agent output — install command offered by the bootstrap itself (`project-init` step 0)
