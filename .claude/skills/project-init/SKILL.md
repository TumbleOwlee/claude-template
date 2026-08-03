---
name: project-init
description: Interactive one-shot bootstrap of a forked repo-template into a real project — asks for project name, purpose, language stack, capability areas and coverage floor, then writes AGENTS.md, CLAUDE.md, PRD.md, ARCHITECTURE.md, CONTRIBUTING.md, docs/specs/, CI and git hooks, and removes the template scaffolding. Use when the user runs /init, /project-init, says "initialize this repo", "set up the project", or the repo still contains templates/ and a bootstrap CLAUDE.md.
---

# Project init

Turn this forked template into a configured, spec-driven TDD project. One run,
then the template scaffolding is gone and the repo looks like a normal project.

Everything the generated project needs comes from `templates/`. Read the
template files — do not reproduce their content from memory, and do not
paraphrase the workflow gates. The gate text is the product.

## Guard rails

- **Ask, never guess.** Every unknown below is an `AskUserQuestion`, not an
  assumption. A wrong build command baked into AGENTS.md is worse than one
  question.
- **Never fabricate requirements.** `docs/specs/*/requirements.md` ships as an
  empty, header-only stub. Real "shall" statements are written later through
  gate 1 of the workflow. Same for PRD sections you cannot ground — `*(TBD)*`.
- **Never overwrite a file the user wants kept.** Step 1 settles that per file.
- **Do not start implementing the product.** This skill sets up the workflow.
  The first feature goes through gate 1 afterwards.

## 0. Check the toolchain

Check whether the `caveman` skill is available (it appears in the skills listing
as `caveman` or `caveman:caveman`). If it is missing, tell the user they can
install it and give them the command to run themselves — it is a `claude` CLI
call, not something to run for them:

```sh
claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman
```

It is optional. Say so, do not block on it, and continue with step 1 either way.

## 1. Detect state

Check what already exists: `AGENTS.md`, `CLAUDE.md`, `PRD.md`,
`ARCHITECTURE.md`, `CONTRIBUTING.md`, `README.md`, `docs/specs/`,
`.github/workflows/`, `.lefthook.yml`, and any language manifest
(`Cargo.toml`, `package.json`, `pyproject.toml`, `setup.py`, `go.mod`,
`CMakeLists.txt`).

A pristine fork has only the bootstrap `CLAUDE.md`, `README.md`, `templates/`
and `.claude/` — treat those three as template scaffolding to be replaced, not
as user content, and do not ask about them.

`.claude/tasks/` (the agent task board) and `.claude/settings.json` (its
`SessionStart` detector) ship with the fork ready to use. Create nothing there,
ask nothing about them, delete nothing — an empty board is the correct state for
a project that has not run a feature yet.

For any *other* pre-existing target file, show it and ask: keep / overwrite /
merge. Record the decision; step 7 honours it.

If `AGENTS.md` already exists and looks like this workflow (it contains "Gate 1"),
say so and ask whether the user wants a re-run (re-ask everything and rewrite) or
a targeted edit instead. A re-run on a live project silently discards local
customisation — make that explicit before proceeding.

## 2. Ask the project facts

One `AskUserQuestion` round, batching what you cannot infer. Infer first from
the git remote name, the directory name, and any existing README or manifest —
then ask to confirm rather than ask blind.

- **Project name** — defaults to the repo directory name.
- **One-line description** — what it is, for the PRD overview and manifest.
- **Kind** — library / binary / service / CLI / TUI / other. Drives whether
  ARCHITECTURE.md talks about a public API surface or a process lifecycle.
- **License** — only if `LICENSE` is absent, and only to decide whether to
  mention one; do not write a license file unless asked.

## 3. Ask the stack

Detect from manifests if any exist. Otherwise ask. Supported stacks, one file
each under `templates/stacks/`:

| Stack | File | Manifest marker |
|---|---|---|
| Rust | `templates/stacks/rust.md` | `Cargo.toml` |
| Python | `templates/stacks/python.md` | `pyproject.toml`, `setup.py` |
| Node / TypeScript | `templates/stacks/node.md` | `package.json` |
| Go | `templates/stacks/go.md` | `go.mod` |
| C / C++ (CMake) | `templates/stacks/cmake.md` | `CMakeLists.txt` |

Read the chosen stack file. It is the single source for that stack's build /
test / lint commands, narrow-loop commands, test naming conventions, coverage
tool, CI job matrix and pre-commit hook bodies. Every `{{…}}` slot the other
templates carry is filled from it.

Then **confirm the command block with the user before it is written anywhere**.
Show the exact commands; let them correct any line. If the stack file offers
variants (pnpm vs npm, ninja vs make, ruff vs flake8), ask which — do not pick
silently.

If the user's stack is not in the table, ask them for the five commands
(build/check, test, lint, format-check, coverage) and their unit/integration
test naming convention, then proceed with those; skip the stack-specific CI and
hook fragments and generate a minimal CI job that runs exactly those commands.

## 4. Ask the capability areas

The areas are the spine of `docs/specs/` and of AGENTS.md's routing table.
Ask for 2–6, grounded in what you now know about the project — give concrete
example areas for *this* project, not an abstract prompt.

For each area, agree:

- a directory name (lowercase, short: `frame`, `client`, `transport`),
- a one-line "covers" description for the routing tables,
- a **requirement ID prefix**, two letters plus `-R-` (`FR-R-nnn`,
  `CL-R-nnn`). Prefixes must be unique and must not collide with `NF-R-*`,
  which is reserved for non-functional requirements.

If the user does not know the areas yet, do not invent them: write
`docs/specs/README.md` with the "populate as you go" note, create only
`non-functional-requirements.md`, and put a TBD row in the AGENTS.md routing
table. The workflow still functions — gate 1 creates the first area.

Also ask, in the same round:

- **Coverage floor** (default 80, CI-gated). "None" is allowed and removes the
  coverage line from AGENTS.md, CONTRIBUTING.md and CI.
- **Which per-area files** each area starts with. Default `requirements.md` +
  `edge-cases.md`; add `api-contract.md` for anything with a public surface and
  `data-contract.md` for anything with a wire or file format.
- **Issue tracker** — GitHub (`gh`) or none. With none, gate 1b becomes "record
  the goal in the PR body" and every `gh` command drops out of AGENTS.md.

## 5. Ask the scope boundaries

AGENTS.md ends with "Scope boundaries — ask before". Generic entries are dead
weight; project-specific ones are the most valuable lines in the file. Propose
3–5 drawn from what you now know (adding a dependency, changing the public API
surface, supporting a new protocol version, adding a second runtime) and let the
user edit, drop or add. Keep only ones that are true for this project.

## 6. Confirm the plan

Before writing anything, show a compact summary: project name, stack, command
block, areas with prefixes, coverage floor, tracker, files that will be created,
files that will be overwritten, files that will be deleted. Get a yes.

This is the only approval gate in this skill. After it, write everything without
further prompting.

## 7. Write the files

Read each template, substitute every placeholder, write to the repo root.
Never leave a `{{PLACEHOLDER}}` in an output file — an unfilled slot is a bug.
Grep the written files for `{{` before reporting; a leak means you missed a slot.

Three things substitution alone does not handle:

- **`<!-- PRUNE ME -->` blocks.** `AGENTS.md.tmpl` marks its stack-neutral
  conventions this way. Drop the bullets that do not apply to this project, merge
  any the stack block restates in stack-specific terms (keep the specific wording),
  and delete the marker comment. Two bullets saying the same thing in different
  words is how a conventions section starts getting ignored.
- **Source paths in the hook blocks.** The `spec-reminder` and `test-id-reminder`
  hooks match product code by path (`^src/`, `^(src|include)/`, `*.go`). Point them
  at this project's actual source directory, or the reminder never fires.
- **Line wrapping.** The prose templates wrap at ~80 columns. A substituted slot
  that runs long (the coverage line, a stack name, an area description) gets
  re-wrapped to match, not left as one long line.

| Template | Output |
|---|---|
| `templates/AGENTS.md.tmpl` | `AGENTS.md` |
| `templates/CLAUDE.md.tmpl` | `CLAUDE.md` (replaces the bootstrap one) |
| `templates/PRD.md.tmpl` | `PRD.md` |
| `templates/ARCHITECTURE.md.tmpl` | `ARCHITECTURE.md` |
| `templates/CONTRIBUTING.md.tmpl` | `CONTRIBUTING.md` |
| `templates/README.md.tmpl` | `README.md` (replaces the template's own) |
| `templates/docs/specs/README.md.tmpl` | `docs/specs/README.md` |
| `templates/docs/specs/non-functional-requirements.md.tmpl` | `docs/specs/non-functional-requirements.md` |
| `templates/docs/specs/area/*.tmpl` | `docs/specs/<area>/*` — once per area, per step 4 |
| stack file's `ci` block | `.github/workflows/check.yml` |
| stack file's `lefthook` block | `.lefthook.yml` |
| stack file's `config` blocks | stack config files (e.g. `clippy.toml`, `ruff.toml`) — only those the stack file marks as default |

Also append the stack's build artifacts to `.gitignore` (`target/` for Rust,
`node_modules/` and `dist/` for Node, `.venv/`, `__pycache__/`, `.pytest_cache/`,
`.mypy_cache/` for Python, `cover.out` for Go, `build/` for CMake). The template
`.gitignore` carries only the language-agnostic entries and a comment saying so —
replace that comment with the real entries.

Placeholders used across templates:

| Placeholder | From |
|---|---|
| `{{PROJECT_NAME}}`, `{{ONE_LINER}}`, `{{PROJECT_KIND}}` | step 2 |
| `{{STACK_NAME}}`, `{{FULL_COMMANDS}}`, `{{NARROW_COMMANDS}}`, `{{UNIT_TEST_CONVENTION}}`, `{{INTEGRATION_TEST_CONVENTION}}`, `{{ID_CITATION_EXAMPLE}}`, `{{STACK_CONVENTIONS}}`, `{{SETUP_STEPS}}` | step 3 stack file |
| `{{AREA_ROUTING_TABLE}}` | step 4 — AGENTS.md rows, links relative to the repo root (`./docs/specs/<area>/`) |
| `{{AREA_TABLE}}` | step 4 — **link base differs per file**: `./<area>/` in `docs/specs/README.md`, `./docs/specs/<area>/` in `PRD.md`. Same rows, different hrefs; get this wrong and every link in one of the two files is dead. |
| `{{COVERAGE_FLOOR}}`, `{{COVERAGE_LINE}}` | step 4 |
| `{{ISSUE_WORKFLOW}}` | step 4 tracker choice |
| `{{SCOPE_BOUNDARIES}}` | step 5 |
| `{{AREA_TITLE}}`, `{{AREA_COVERS}}`, `{{AREA_PREFIX}}` | step 4, per area file |
| `{{ID_CITATION_BLOCK}}`, `{{COVERAGE_CONTRIB_LINE}}` | stack file + coverage floor |
| `{{ID_PREFIX_ALTERNATION}}` | step 4 prefixes joined with `\|`, e.g. `FR\|CL\|SV\|NF` — used in the lefthook reminder regex |
| `{{PROJECT_UPPER}}` | project name upper-cased, `-` → `_` (CMake cache variables) |

Coverage-dependent slots, all filled from the floor chosen in step 4 — and all
removed entirely, leaving no dangling clause, when the user chose "none":

| Placeholder | With a floor of N | With no floor |
|---|---|---|
| `{{COVERAGE_FLOOR}}` | `N` | — (the coverage command is dropped) |
| `{{COVERAGE_LINE}}` | `- Coverage floor N% of lines, CI-gated on every push and PR. A floor, not a target — never inflate it with tests that execute code without asserting.` | empty |
| `{{COVERAGE_GAUNTLET_WORD}}` | `/coverage` | empty |
| `{{COVERAGE_PLAN_CLAUSE}}` | `; expected coverage impact` | empty |
| `{{COVERAGE_STAGE_CLAUSE}}` | `, coverage ≥ N%` | empty |
| `{{COVERAGE_PR_CLAUSE}}` | `, the coverage number` | empty |
| `{{COVERAGE_CONTRIB_LINE}}` | `Line coverage must stay at or above **N%**, enforced in CI. Coverage is a floor, not a goal — never pad it with tests that execute code without asserting on it.` | empty |

Tracker-dependent slots:

| Placeholder | GitHub | No tracker |
|---|---|---|
| `{{ISSUE_WORKFLOW}}` | the gate 1b body from `templates/fragments/issue-github.md` | the body from `templates/fragments/issue-none.md` |
| `{{CLOSES_CLAUSE}}` | `, ` + `` `Closes #<issue>` `` | empty |

**Substitute only the placeholders named above.** A GitHub Actions expression like
`${{ matrix.python-version }}` inside a CI block is not a placeholder — copy it
through verbatim.

Do **not** create the language manifest (`Cargo.toml`, `package.json`, …) or any
source file. Scaffolding a project skeleton is the first task *through* the
workflow, not part of setting it up — gate 1 owns the first behavior.

## 8. Remove the template scaffolding

Delete `templates/`, `.claude/skills/project-init/` and
`.claude/skills/init-workspace/`.
Keep `.claude/agents/`, the remaining `.claude/skills/`, `.claude/tasks/` and
`.claude/settings.json` — the workflow uses them. Do not delete `.git`, and do not commit; leave the working tree dirty so
the user reviews the diff.

## 9. Report and hand over

State what was created, overwritten and deleted, then the three things the user
does next:

1. Review the diff and commit the scaffolding on `main` (this is the one commit
   that legitimately lands on `main` without going through the gates).
2. Install the hook runner if lefthook was generated (`lefthook install`).
3. Start the first feature: describe it, and the agent opens **gate 1** — the
   spec diff — before any code.

Then stop. Do not roll into the first feature.
