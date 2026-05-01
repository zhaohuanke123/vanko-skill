# Version Control Reference

Load this file when initializing a project, changing implementation, creating a milestone,
preparing delivery, or recovering from mistakes.

## Git Is Required Unless Explicitly Blocked

Use Git to manage the project history and record meaningful changes.

1. At project start, check `git rev-parse --is-inside-work-tree`.
2. If not in a Git repository, ask whether to initialize Git before creating project files.
3. If the user declines Git, record `Version control: manual` in `PROJECT.md` and continue
   with document-based version history.
4. Never run destructive Git commands such as `git reset --hard` or `git checkout --` unless
   the user explicitly asks for that operation.

## Commit Discipline

Use small, meaningful commits at stable checkpoints:

- After initial project scaffolding and context files.
- After each approved phase document.
- Before implementation work that depends on a design update.
- After a coherent implementation slice plus passing verification.
- After delivery docs, version history, and lessons are updated.

Commit messages should name the intent, not the mechanics:

```text
docs: define export requirements
design: add batch export workflow
feat: implement batch zip export
test: cover failed conversation handling
release: deliver v1.2.0
```

## Git Workflow

Before edits:

1. Run `git status --short`.
2. Identify user changes already present.
3. Do not overwrite or revert unrelated changes.

After edits:

1. Run targeted tests or checks.
2. Run `git status --short`.
3. Review the diff for only intended changes.
4. Commit when the work reaches a coherent checkpoint and the user has not asked to avoid commits.

For larger changes, use a branch:

```text
feature/[short-topic]
fix/[short-topic]
release/vX.Y.Z
```

## Releases and Tags

For every release or milestone:

1. Update `PROJECT.md` current version and status.
2. Update `docs/version-history.md` with changes, verification, docs updated, rollback note,
   and Git commit or tag.
3. Commit the release documentation and final code.
4. Create an annotated tag when appropriate:

```text
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

If tags are not created, record the release commit hash in `docs/version-history.md`.

## Rollback

Prefer forward-moving recovery:

- Use `git revert <commit>` for committed regressions.
- Use a new corrective commit for documentation mistakes.
- Avoid history rewriting on shared or unclear branches.

Record rollback actions in `docs/version-history.md` and update `PROJECT.md` resume context.
