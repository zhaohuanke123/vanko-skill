# Context Files Reference

Load this file when creating or repairing `PROJECT.md`, `CLAUDE.md`,
`docs/version-history.md`, or `docs/lessons-learned.md`.

## PROJECT.md

Single source of truth for project state. Write it in Phase 1 and update it after every
phase transition.

```markdown
# Project: [Name]

## Status
- Current Phase: Phase N — [Name]
- Current Version: v0.0.0 / Unreleased / vX.Y.Z
- Last Updated: [date]

## One-Line Summary
[What this project is, in one sentence]

## Key Decisions
- Tech stack: [chosen stack]
- Lifecycle: [chosen model]
- Version strategy: [semver/date-based/manual milestone]
- Version control: Git / manual fallback

## Phase Progress
- [ ] Phase 1: Problem Definition — `docs/problem-definition.md`
- [ ] Phase 2: Requirements — `docs/requirements.md`
- [ ] Phase 3: Planning — `docs/plan.md`
- [ ] Phase 4: Architecture — `docs/architecture.md`
- [ ] Phase 5: Detailed Design — `docs/design.md`
- [ ] Phase 6: Coding — source directories
- [ ] Phase 7: Unit Testing — test directories
- [ ] Phase 8: Integration
- [ ] Phase 9: System Testing — `docs/test-results.md`
- [ ] Phase 10: Delivery — `README.md`, `docs/version-history.md`, `docs/lessons-learned.md`

## Version Status
- Latest release:
- Git branch:
- Git commit/tag:
- Verification:
- Rollback note:

## Resume Context
[2-3 sentences enough for a new conversation to continue.]
```

## CLAUDE.md

First file a generic agent reads. It prevents context loss when this skill is not explicitly
loaded.

```markdown
# CLAUDE.md

## Project State
- Status: [Phase / Delivered / Cancelled]
- Current version: [vX.Y.Z or Unreleased]
- Last updated: [date]
- Primary status file: `PROJECT.md`

## Progressive Context Loading
Read only what the task needs:

1. Always read `PROJECT.md` first for status, version, and resume context.
2. For requirements or scope questions, read `docs/problem-definition.md` and `docs/requirements.md`.
3. For architecture or design questions, read `docs/architecture.md` and `docs/design.md`.
4. For implementation work, read `docs/design.md`, relevant source files, and matching tests.
5. For verification, read `docs/test-results.md` and run the commands below.
6. For release or regression questions, read `docs/version-history.md`.
7. For recurring pitfalls, read `docs/lessons-learned.md`.
8. For Git, commits, tags, or rollback, read the skill reference `references/version-control.md`.

## Durable Documents
- `PROJECT.md` — status, phase, version, resume context
- `docs/problem-definition.md` — problem and success criteria
- `docs/requirements.md` — requirements
- `docs/plan.md` — stack, milestones, risks, version strategy
- `docs/architecture.md` — components and data flow
- `docs/design.md` — module design and contracts
- `docs/test-results.md` — verification
- `docs/version-history.md` — release and rollback history
- `docs/lessons-learned.md` — reusable lessons
- `README.md` — setup and usage

## Development Workflow
1. Update the relevant document before changing implementation.
2. Implement only what the document describes.
3. Run targeted tests or checks.
4. Reconcile docs, code, tests, and README if behavior changed.
5. Record version history or lessons when the change affects release state or future work.
6. Use Git commits/tags to record approved checkpoints unless version control is explicitly disabled.

## Commands
- Install:
- Test:
- Run:
- Build:
```

## docs/version-history.md

Use for every milestone, release, rollback, or user-visible behavior change.

```markdown
# Version History

## Unreleased
- Status:
- Planned changes:

## vX.Y.Z — [date]

### Git
- Branch:
- Commit:
- Tag:

### Changes
- [User-visible change]

### Verification
- [Command or manual scenario] — Pass/Fail

### Documentation Updated
- [Files updated]

### Rollback Note
- [How to revert or what previous version was stable]
```

## docs/lessons-learned.md

Use this file to teach future agents. Keep entries concise and actionable.

```markdown
# Lessons Learned

## [YYYY-MM-DD] [Short Title]
- Context:
- Lesson:
- Apply next time:
- Related files:
```
