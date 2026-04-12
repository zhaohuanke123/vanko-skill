# Vanko Skill

A Claude Code skills marketplace containing personal AI development utilities.

## Available Skills

### task-driven-ai-dev

Turn a repository into a task-driven AI delivery loop with durable planning artifacts, guarded single-task execution, progress logging, and validation gates.

**Features:**
- **Architecture Documentation**: Maintain system overview, constraints, and integration boundaries
- **Task Management**: Track backlog with dependencies, blocked state, and validation notes
- **Progress Logging**: Dated execution log with testing evidence
- **Project Configuration**: Repo-specific commands and artifact paths
- **Git Integration**: Automatic commit after task completion

### coding-workflow

A structured development workflow for fullstack projects with verification gates, persistent state, and browser testing integration.

**Features:**
- **Task Selection**: Automatically select next incomplete task from task.json
- **Implementation Guidance**: Follow existing code patterns and conventions
- **Testing Gates**: Lint, build, and browser testing with MCP Playwright
- **Progress Documentation**: Persistent session history in progress.txt
- **Blocking Protocol**: Clear handling of tasks that require human intervention
- **Rollback Support**: Clean recovery from failed implementations

## Installation

### From GitHub Marketplace

```shell
/plugin marketplace add zhaohuanke123/vanko-skill
```

### Install Specific Skills

```shell
# Task-driven AI development
/plugin install task-driven-ai-dev@zhaohuanke123-vanko-skill

# Coding workflow
/plugin install coding-workflow@zhaohuanke123-vanko-skill
```

### Local Development

```bash
git clone https://github.com/zhaohuanke123/vanko-skill.git
claude --plugin-dir ./vanko-skill
```

## Usage

```shell
# Task-driven AI development
/task-driven-ai-dev:task-driven-ai-dev

# Coding workflow
/coding-workflow:coding-workflow
```

## Required Artifacts

### For task-driven-ai-dev

| File | Purpose |
|------|---------|
| `architecture.md` | System overview, constraints, integration boundaries |
| `task.json` | Backlog source of truth with task definitions |
| `progress.txt` | Dated execution log with evidence |
| `project-config.json` | Repo-specific commands and artifact paths |

### For coding-workflow

| File | Purpose |
|------|---------|
| `task.json` | Task definitions with steps and completion status |
| `progress.txt` | Session history and context |
| `architecture.md` | System design decisions |
| `init.sh` | Environment setup script |

## License

MIT
