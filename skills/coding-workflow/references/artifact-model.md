# Artifact Model

This document describes the key artifacts used in coding-workflow.

## task.json

**Purpose**: Single source of truth for project tasks

**Schema**:

```typescript
interface Task {
  id: number;
  title: string;
  description: string;
  steps: string[];
  passes: boolean;
  priority?: 'critical' | 'high' | 'medium' | 'low';
  dependencies?: number[];
  testing?: 'browser' | 'unit' | 'integration';
}

interface TaskFile {
  project: string;
  description: string;
  version?: string;
  tasks: Task[];
  metadata?: {
    created: string;
    tech_stack?: Record<string, string>;
  };
}
```

**Mutation Rules**:
- Only modify `passes` field
- Never remove tasks
- Never modify task IDs
- Never modify step descriptions mid-development

## progress.txt

**Purpose**: Development history and context for future sessions

**Format**:

```
## [YYYY-MM-DD] - Task #N: [Title] | [BLOCKED]

### What was done:
- [List of changes]

### Testing:
- [Testing method and results]

### Notes:
- [Context and decisions]
```

**Retention**:
- Keep all entries (append-only)
- Do not modify past entries
- Use for debugging and context

## architecture.md

**Purpose**: System design documentation

**Sections**:
1. Overview
2. Tech Stack
3. Directory Structure
4. Data Model
5. API Design
6. Key Decisions
7. Environment Variables

**Updates**: Modify when architectural decisions change

## init.sh

**Purpose**: Environment initialization

**Requirements**:
- Idempotent (safe to run multiple times)
- Install all dependencies
- Start development server
- Exit with error code on failure

**Example**:

```bash
#!/bin/bash
set -e

echo "Installing dependencies..."
npm install

echo "Starting dev server..."
npm run dev &

echo "Ready!"
```

## project-config.json

**Purpose**: Externalize repo-specific commands and paths

**Schema**:

```typescript
interface ProjectConfig {
  name: string;
  version: string;
  commands: {
    dev: string;
    build: string;
    lint: string;
    test?: string;
  };
  testing: {
    browser_required_for: string[];
    lint_required: boolean;
    build_required: boolean;
  };
  commit: {
    include_files: string[];
    message_format: string;
  };
  blocking: {
    stop_on_block: boolean;
    require_human_confirmation: string[];
  };
}
```
