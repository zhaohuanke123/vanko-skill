# Coding Workflow

A structured development workflow skill for Claude Code, designed for fullstack frontend/backend projects.

## Overview

This skill implements a task-driven development workflow that helps AI agents:

- Work on one task at a time
- Verify changes with lint, build, and browser tests
- Maintain persistent state across sessions
- Handle blocking situations gracefully
- Commit changes atomically

## Installation

Copy this skill to your Claude Code skills directory:

```bash
# For project-level use
cp -r skills/coding-workflow ~/.claude/skills/

# Or keep it in your project
# The skill will be available when working in this project
```

## Quick Start

1. **Initialize your project** with the required files:

```bash
# Copy templates to your project root
cp skills/coding-workflow/assets/templates/task.json ./task.json
cp skills/coding-workflow/assets/templates/progress.txt ./progress.txt
cp skills/coding-workflow/assets/templates/architecture.md ./architecture.md
```

2. **Define your tasks** in `task.json`:

```json
{
  "project": "My Project",
  "description": "A fullstack application",
  "tasks": [
    {
      "id": 1,
      "title": "Setup Environment",
      "description": "Initialize project structure",
      "steps": ["Create package.json", "Setup TypeScript", "Configure Tailwind"],
      "passes": false,
      "priority": "critical"
    }
  ]
}
```

3. **Create `init.sh`** for environment setup:

```bash
#!/bin/bash
set -e
npm install
npm run dev &
```

4. **Invoke the skill**:

```
/coding-workflow
```

## Usage

### Continue Development

```
/coding-workflow
```

or

```
continue
```

The agent will:
1. Read `task.json`
2. Find the next incomplete task
3. Implement it
4. Test and verify
5. Update `progress.txt`
6. Commit changes

### Check Status

```
/coding-workflow status
```

Shows:
- Completed vs remaining tasks
- Current blocking issues
- Next task to work on

### Work on Specific Task

```
/coding-workflow task 5
```

## Project Files

| File | Purpose |
|------|---------|
| `task.json` | Task definitions (source of truth) |
| `progress.txt` | Development history |
| `architecture.md` | System design documentation |
| `init.sh` | Environment setup script |
| `CLAUDE.md` | Project-specific instructions |

## Key Features

### 1. Task-Driven Development

- Each session focuses on ONE task
- Tasks have clear steps and acceptance criteria
- Dependencies are respected

### 2. Verification Gates

- All changes must pass `npm run lint`
- All changes must pass `npm run build`
- UI changes require browser testing with MCP Playwright

### 3. Persistent State

- `task.json` tracks task completion
- `progress.txt` preserves context across sessions
- Future agents can understand what was done

### 4. Blocking Protocol

When a task cannot be completed:
- Agent documents the block in `progress.txt`
- No commit is made
- Clear instructions for human intervention

### 5. Atomic Commits

All changes are committed together:
- Code changes
- `progress.txt` update
- `task.json` update

## Scripts

### select_next_task.py

Select the next ready task from `task.json`:

```bash
python skills/coding-workflow/scripts/select_next_task.py --task-file task.json
```

Options:
- `--format json` - Output as JSON
- `--allow-blocked` - Include blocked tasks

### validate_iteration.py

Validate task completion:

```bash
python skills/coding-workflow/scripts/validate_iteration.py --task-id 1
```

Options:
- `--task-file` - Path to task.json
- `--progress-file` - Path to progress.txt
- `--project-dir` - Project directory for lint/build
- `--skip-lint` - Skip lint check
- `--skip-build` - Skip build check

## Best Practices

### For Humans

1. **Write clear task descriptions** - Each task should be completable in one session
2. **Define dependencies** - Help the agent understand task order
3. **Provide working init.sh** - Ensure environment is reproducible
4. **Document architecture** - Help agents understand the system

### For Agents

1. **Read before writing** - Understand existing patterns
2. **Test thoroughly** - Never skip verification
3. **Document in progress.txt** - Help future agents
4. **Block, don't fake** - Be honest about blockers

## License

Apache-2.0
