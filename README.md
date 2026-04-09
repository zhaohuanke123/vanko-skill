# Task-Driven AI Dev Package

This package extracts the reusable AI development harness from this repository and makes it portable across Codex, Claude Code, and Cursor.

## Package Layout

- `codex-skill/task-driven-ai-dev/`: OpenAI Codex-compatible skill package.
- `claude-agent/task-driven-ai-dev.md`: Claude Code subagent.
- `cursor-rule/task-driven-ai-dev.mdc`: Cursor project rule.
- `install.ps1` and `install.sh`: convenience installers for common targets.

## What It Standardizes

- Architecture-first planning
- Task backlog as source of truth
- Durable progress logging
- One-task-per-iteration execution
- Validation gates before completion
- Subagent orchestration instead of blind shell loops

## Install

### Codex

User scope:

```powershell
./install.ps1 -Target codex
```

Project scope:

```powershell
./install.ps1 -Target codex -Mode project -Destination <repo-path>
```

### Claude Code

User scope:

```powershell
./install.ps1 -Target claude
```

Project scope:

```powershell
./install.ps1 -Target claude -Mode project -Destination <repo-path>
```

### Cursor

Cursor file-based installation is project-scoped. Install the project rule into the target repository:

```powershell
./install.ps1 -Target cursor -Mode project -Destination <repo-path>
```

## Publish

To publish this package as its own GitHub repository, copy the `packages/task-driven-ai-dev/` directory to a new repo root or split it into a subtree/submodule. The package is already self-contained.

Recommended first-time publish flow:

```powershell
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

## Repo Config

This package also includes its own [project-config.json](./project-config.json). It tells an agent how to validate the package itself and where the shipped artifacts live.
