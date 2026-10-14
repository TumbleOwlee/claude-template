---
name: spec-coverage-audit
description: Find code no requirement covers and get an approved spec diff (new requirements, new capability areas) that catches docs/specs up to the code. Requires a governed spec directory (routing table + spec dir) — refuses otherwise; /spec-scaffold-init creates one. Reports, never handles, the reverse gap (spec with no citing test). Use for "find missing specs", "audit spec coverage", "what's undocumented", or "backfill specs for this code".
---

# Spec coverage audit

**Concise, compact, facts only.**

Direction: **code → no spec**. Reverse (**spec → no test**) is out of scope — step 7 asks, doesn't act.

Guard rails: ask, never guess (`AskUserQuestion` for every unknown); never write a requirement without explicit approval; never fabricate — every entry traces to code actually read.

## 0. Check requirements

An `AGENTS.md` (or `CLAUDE.md`) routing table pointing at a spec directory, and that directory with a `README.md`. Either missing → stop, tell the user to run `/spec-scaffold-init` first. This skill only adds requirements *within* an already-governed structure.

A sibling `spec-scaffold-init/templates/area/` directory is needed only when this run proposes a brand-new area (step 4); checked where used (step 6), its absence doesn't block gap-detection within existing areas.

## 1. Scope

Optional area or path argument narrows the run. None → every area in the routing table.

## 2. Map each area to source

Per area: guess its source directory (area name vs `src/<area>`, or the routing table's "covers" wording), confirm via one `AskUserQuestion` before reading.

## 3. Read and compare — per area

Semantic read, not a citation grep: a grep catches only tests missing an ID, never code with no test at all.

1. Read the area's `requirements.md` (and `edge-cases.md`, so a documented intentional gap isn't re-flagged).
2. Read the source in that area.
3. Compare observable behavior vs stated requirements. Flag uncovered behavior.

Anything fitting no area in scope (or none at all): note separately, never fold into the nearest area.

## 4. Draft the diff

- **Gaps in an existing area**: new `<PREFIX>-R-nnn` entries (indicative statements, README rule 4), one rule each (README rule 9), next free number for that area's prefix (append-only — never reuse or renumber). Testable, observable wording: `**<PREFIX>-R-001** — The <subject> <observable outcome> when <condition>.`
- **Code fitting no area**: propose a new area inline — directory name (lowercase, short), one-line "covers", unique prefix (two letters + `-R-`, not colliding with existing or `NF-R-*`) — then its first requirements.

## 5. Get approval

Present the full draft — grouped by area, new areas called out — for one explicit approval. No tracking issue, no commit — code exists, nothing to track.

Rejected/edited items: adjust, re-confirm before writing.

## 6. Write

New area approved: `spec-scaffold-init/templates/area/*.tmpl` present → write from them (substitute placeholders, only the files needed) and append a routing row:

```
| <area covers> | [`<area>`](<spec-dir>/<area>/) | `<PREFIX>-R-*` |
```

Missing → stop just the new-area part, say new-area scaffolding needs `spec-scaffold-init` alongside this skill; still write the existing-area entries. Then append approved entries to each `requirements.md`.

Report what was written (files, IDs, new area). Stop; the user reviews and commits.

## 7. Ask about the other direction

Last: ask whether a follow-up should report requirements with no citing test (spec → no test), and whether to add to this skill or build separately. Record the answer.
