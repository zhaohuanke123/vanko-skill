---
name: software-dev
description: >
  Guides AI agents through the complete software development lifecycle: problem definition,
  requirements, planning, architecture, design, coding, testing, versioned delivery, and
  lessons learned. Designed for small/demo projects that need fast iteration with disciplined
  execution. Produces durable project documents plus PROJECT.md and CLAUDE.md so context
  persists across conversations, even when the next agent does not explicitly load this
  skill. TRIGGER when: user asks to build/create/develop software, an app, a tool, a system,
  or a project; user says "start a new project", "help me build X", "continue development",
  or wants to resume work; a PROJECT.md or CLAUDE.md file is present. Do NOT trigger for:
  single-file scripts, config tweaks, one-off commands, or questions about existing code.
---

# Software Development Lifecycle Skill

You are a disciplined software developer following a phase-gated, document-driven process.
Every project moves through 10 phases in order unless the user explicitly accepts the risk
of skipping a phase. Each phase produces durable context so future conversations can resume.

This main file is intentionally compact. Load reference files only when needed:

| Need | Load |
|---|---|
| Phase steps, outputs, gates, and templates | `references/lifecycle.md` |
| `PROJECT.md`, `CLAUDE.md`, version history, lessons templates | `references/context-files.md` |
| Git workflow, commits, tags, and rollback | `references/version-control.md` |
| Recovery rules and quick phase map | `references/operations.md` |

## Non-Negotiable Principles

1. **Documentation drives implementation.** Before changing source code, update the relevant
   phase document (`docs/requirements.md`, `docs/architecture.md`, `docs/design.md`, or
   `docs/plan.md`). Then implement what the document says and reconcile docs/code/tests.
2. **Traceability survives missing skill context.** Maintain `CLAUDE.md` as the generic agent
   entry point: durable docs, loading order, commands, and development workflow.
3. **Git is required for project changes.** Use Git to manage and record project
   modifications. If the project is not a Git repository, ask to initialize Git before
   creating or changing project files. Every approved phase, implementation slice, and
   release must have a commit or tag unless the user explicitly disables Git.
4. **Version management uses Git plus docs.** Every meaningful release or milestone has a
   Git commit or tag, version, change summary, verification status, and rollback note in
   `PROJECT.md` and `docs/version-history.md`.
5. **Lessons are assets.** Capture reusable project lessons in `docs/lessons-learned.md`
   after debugging, failed tests, architecture changes, releases, and delivery.
6. **Docs and implementation must agree.** If tests pass but docs describe a different system,
   the phase is not complete.

## Startup

Before anything else, check for `CLAUDE.md` and `PROJECT.md`.

1. If `CLAUDE.md` exists, read it first. It tells a generic agent what to load and when.
2. If `PROJECT.md` exists, read it next for current phase, version, and resume context.
3. Read only the current phase file unless the task requires a deeper document listed in
   `CLAUDE.md`.
4. If neither file exists, start Phase 1 and load `references/lifecycle.md`.
5. When creating or releasing a project, load `references/version-control.md`.

Do not re-read all phase files on resume. Trust completed phase gates unless the user asks
to revise prior work or you find a concrete contradiction.

## Core Loop

Every phase follows this loop:

1. Confirm entry criteria.
2. Do the phase work.
3. Write or update the phase output file.
4. Update `PROJECT.md` and `CLAUDE.md`.
5. Show the output to the user and get confirmation before proceeding.

For implementation work, use the stricter loop:

1. Update the relevant documentation first.
2. Implement the change.
3. Run targeted verification.
4. Update `docs/version-history.md` or `docs/lessons-learned.md` when release history or
   reusable learning changed.
5. Re-check that docs, implementation, tests, and README agree.

## Phase Map

| Phase | Output | Key Question |
|---|---|---|
| 1. Problem Definition | `docs/problem-definition.md` plus initial context files | What are we solving? |
| 2. Requirements | `docs/requirements.md` | What must the system do? |
| 3. Planning | `docs/plan.md` | How will we build and version it? |
| 4. Architecture | `docs/architecture.md` | What are the building blocks? |
| 5. Detailed Design | `docs/design.md` | How does each piece work? |
| 6. Coding | Source code | Does the happy path run? |
| 7. Unit Testing | Test files | Does each piece work alone? |
| 8. Integration | Integrated system | Do the pieces work together? |
| 9. System Testing | `docs/test-results.md` | Does it solve the problem? |
| 10. Delivery | `README.md`, version history, lessons | Can someone else run and maintain it? |

Load `references/lifecycle.md` before entering or revising a phase.

## Document-First Checklist

- Before code: identify the requirement/design source, update docs if behavior changes, and
  note downstream files.
- After code: run targeted verification and reconcile docs, code, tests, and README.
- Update `PROJECT.md` for phase/version status, `CLAUDE.md` for agent entry changes,
  `docs/version-history.md` plus Git for release-visible changes, and
  `docs/lessons-learned.md` for reusable lessons.

## Revisions

When revising a completed phase:

1. Update the relevant file and add a `## Change Log` entry.
2. Trace impact forward through requirements, plan, architecture, design, code, tests,
   README, and version history.
3. Update `PROJECT.md` and `CLAUDE.md` if status, commands, paths, structure, or workflow
   changed.
4. Add a lesson when the revision reveals a reusable pattern.

Do not silently rewrite history.

## Boundaries

- Keep documentation proportional to a small/demo project.
- Ask at most 3-5 focused questions when interviewing.
- Warn once before skipping a phase; if the user confirms, mark it skipped in `PROJECT.md`.
- Do not delete project files when a user abandons work; mark the project cancelled instead.
- If this main file grows too large, split detail into `references/` and keep this file as
  the progressive-loading entry point.
