---
name: spec-scaffold-init
description: Add a governed spec directory (capability areas, requirement-ID convention, routing pointer) to a project — appends to an existing AGENTS.md/CLAUDE.md, or creates a minimal one if neither exists. Does not touch build/test/lint, CI, hooks, or issue-tracker setup. Use when the user wants "just the spec directory", "spec structure only", or "add docs/specs without the full workflow".
---

# Spec scaffold init

**Concise, compact, facts only.**

Gates 2-4 (implementation plan, worktree, review) stay out; step 6's note covers only how a spec change itself gets proposed and approved.

Self-contained: every file written comes from this skill's own `templates/` and `scripts/` (next to this `SKILL.md`); the folder works copied alone into any project.

Guard rails: ask, never guess (`AskUserQuestion` for every unknown below); never fabricate requirement text (every generated file ships as a stub — real statements land later, through step 6's approval note); never overwrite a file without asking keep/overwrite/merge.

## 0. Check requirements

`templates/` and `scripts/` exist next to this `SKILL.md`. Either missing → incomplete copy; stop, ask for the whole `spec-scaffold-init/` directory.

## 1. Detect existing agent-instructions file

`AGENTS.md`, else `CLAUDE.md` → the append target for step 6. Neither → step 6 creates a minimal `AGENTS.md`.

## 2. Ask the spec directory location

`AskUserQuestion`, default `docs/specs`. Below: `<spec-dir>`, the confirmed answer — never a hardcoded `docs/specs`.

## 3. Ask the capability areas

One `AskUserQuestion` round, 2-6 areas, each with a directory name (lowercase, short: `frame`, `client`, `transport`), a one-line "covers" for the routing table, and a requirement ID prefix — two letters + `-R-` (`FR-R-nnn`), unique, never `NF-R-*` (reserved for non-functional requirements). Same round: per-area starting files — default `requirements.md` + `edge-cases.md`; `api-contract.md` for a public surface, `data-contract.md` for a wire or file format.

User doesn't know the areas → don't invent: the fallback in step 5 (only `non-functional-requirements.md` + `README.md`, a TBD routing row); areas are added later the same way.

## 4. Confirm before writing

Compact summary — location, areas with prefixes and starting files, files to create, file to append to (or "new minimal AGENTS.md") — one yes. The only approval gate; then write without further prompting.

## 5. Write the files

From `templates/` (paths relative to this `SKILL.md`), placeholders substituted:

| Bundled template | Output |
|---|---|
| `templates/README.md.tmpl` | `<spec-dir>/README.md` |
| `templates/non-functional-requirements.md` | `<spec-dir>/non-functional-requirements.md` (copy as-is) |
| `templates/area/requirements.md.tmpl` | `<spec-dir>/<area>/requirements.md` — per area |
| `templates/area/edge-cases.md.tmpl` | `<spec-dir>/<area>/edge-cases.md` — per area |
| `templates/area/api-contract.md.tmpl` | `<spec-dir>/<area>/api-contract.md` — areas that asked |
| `templates/area/data-contract.md.tmpl` | `<spec-dir>/<area>/data-contract.md` — areas that asked |

`{{PROJECT_NAME}}`: the repo directory name, inferred silently. `README.md.tmpl` carries no area table — it points at the routing table step 6 appends, the single copy of the area list. `{{AREA_TITLE}}`/`{{AREA_COVERS}}`/`{{AREA_PREFIX}}`: step 3's answers.

Fallback (no areas): write only `<spec-dir>/non-functional-requirements.md` and `<spec-dir>/README.md` with a "populate as you go" note; step 6 appends a TBD routing row.

Copy this skill's `scripts/extract-id.sh`, `extract-section.sh`, `list-sections.sh`, `token-rank.sh` into `.claude/scripts/`, `chmod +x`, skip existing. Grep every written file for `{{` — a leak is a missed placeholder.

## 6. Append the routing section

To the file from step 1 (or the new minimal `AGENTS.md`), exactly three things:

1. **Routing table** — one row per area plus the fixed non-functional row:

   ```
   | Task touches | Read | ID prefix |
   |---|---|---|
   | <area covers> | [`<area>`](<spec-dir>/<area>/) | `<PREFIX>-R-*` |
   | Cross-cutting (platforms, performance, security, versioning, testing) | [`non-functional-requirements.md`](<spec-dir>/non-functional-requirements.md) | `NF-R-*` |
   ```

2. **ID citation convention** — IDs stable and append-only, never renumbered or reused once retired; cited in commits/PRs/tests.
3. **Minimal spec-handling note** — before adding or changing a requirement in `<spec-dir>/`, propose the diff and get explicit approval from the project owner, then write. Nothing about plans, worktrees or review.

A new minimal `AGENTS.md` = those three items plus a one-line title/repo description, nothing else.

## 7. Report and hand over

State what was created and what was appended or created for the agent-instructions file. Stop: no requirements, no issue, no commit.
