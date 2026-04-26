---
name: coding-workflow
description: |
  A structured development workflow for fullstack projects with parallel subagent execution.
  Use this skill when you need to implement features systematically, track progress across sessions, and maintain code quality through testing.
  TRIGGER when: user wants to work on tasks from task.json; user asks to continue development; user mentions "next task" or "coding workflow"; project has task.json file.
  DO NOT TRIGGER when: no task.json exists; user asks for a single quick fix without structured workflow.
license: Apache-2.0
---

# Coding Workflow

A disciplined workflow for implementing fullstack features with parallel subagent execution, git worktree isolation, and independent verification.

---

> **⚠️ FIRST: Check Project Architecture Files**
>
> Before any task execution, check if these files exist in the project:
> - `<project-root>/AGENTS.md` — Project navigation entry
> - `<project-root>/architecture.md` — Architecture constraints (tech stack, directory structure, key constraints)
>
> If missing, run **Mode 5: Initialize Project** to generate them.
>
> All code changes MUST comply with `architecture.md` constraints.

---

## Architecture

```
Orchestrator (main agent)
  ├── reads task.json, analyzes dependency graph
  ├── creates git worktrees for parallel tasks
  ├── spawns Executor subagents (one per task, parallel)
  ├── spawns Verifier subagents (one per task, parallel)
  ├── merges worktree branches back to main
  └── commits task.json + progress.txt updates
```

Three agent roles:
- **Orchestrator** — coordinates batches, manages worktrees, merges results
- **Executor** — implements a single task in an isolated worktree
- **Verifier** — independently reviews and tests an executor's output

## Quick Start

1. **Initialize**: Run `./init.sh` to install dependencies and start dev server
2. **Plan**: Run `plan_batches.py` to identify parallelizable tasks
3. **Execute**: Orchestrator spawns executor subagents in worktrees
4. **Verify**: Orchestrator spawns verifier subagents for each result
5. **Merge**: Merge passed worktrees, rollback failed ones
6. **Commit**: Update task.json and progress.txt

---

## Operation Modes

### Mode 1: Continue (Default)

When user says "continue", "next task", or invokes without arguments:

1. Read `task.json` from project root
2. Run `python scripts/plan_batches.py --task-file task.json --format json`
3. Take the first batch of parallelizable tasks
4. Execute the full batch workflow below
5. Report results

### Mode 2: Specific Task

When user specifies a task ID or description:

1. Locate the specific task in `task.json`
2. Implement it as a single-task batch (no parallelism needed)
3. Verify and commit

### Mode 3: Status

When user asks for status or progress:

1. Read `task.json`
2. Summarize completed vs remaining tasks
3. Show which tasks are ready for parallel execution
4. Show current blocking issues from `progress.txt`

### Mode 4: Run All

When user says "run all" or "execute all ready tasks":

1. Run `plan_batches.py` to get all batches
2. Execute every batch in sequence (tasks within each batch run in parallel)
3. Report full results at the end

### Mode 5: Initialize Project

When user says "init project", "initialize", "开始新项目", or project lacks architecture files:

1. Check if `AGENTS.md` and `architecture.md` exist
2. If missing, follow the architecture generation flow:
   - Read `references/architecture-generation.md` for guidance
   - Collect requirements from user (project goal, features, tech preferences)
   - Generate `AGENTS.md` (project navigation entry, ~60-100 lines)
   - Generate `architecture.md` (architecture constraints)
   - Use templates from `assets/templates/`
3. Run `python scripts/validate_architecture.py` to verify completeness
4. Report generated files and ask user to review

---

## Core Workflow

### Step 1: Environment Initialization

**Required at session start:**

```bash
./init.sh
```

If `init.sh` does not exist:
- Check for `package.json` and run `npm install`
- Start dev server with appropriate command (`npm run dev`, etc.)

### Step 2: Plan Batches

Use the batch planning script to identify which tasks can run in parallel:

```bash
python scripts/plan_batches.py --task-file task.json --format json
```

The script analyzes the dependency graph and file overlap to produce batches:

```json
{
  "batches": [
    {
      "batch_id": 1,
      "parallel_count": 2,
      "tasks": [
        {
          "id": 5,
          "title": "Add user profile page",
          "branch": "feature/task-5",
          "worktree": ".worktrees/task-5",
          "files": ["src/app/profile/", "src/components/user/"]
        },
        {
          "id": 7,
          "title": "Add settings API",
          "branch": "feature/task-7",
          "worktree": ".worktrees/task-7",
          "files": ["src/app/api/settings/"]
        }
      ]
    }
  ]
}
```

**How the script decides parallelizability:**
- All dependencies must be satisfied (referenced tasks must have `passes: true`)
- Tasks in the same batch must not share `conflict_groups`
- Tasks must not have overlapping `files` paths (directory-level check)

### Step 3: Create Worktrees

For each task in the current batch, create an isolated git worktree:

```bash
git worktree add .worktrees/task-<ID> -b feature/task-<ID>
```

After this, each subagent has its own working directory on its own branch.

### Step 4: Spawn Executor Subagents

Spawn one executor subagent per task in the batch, all in parallel using the Agent tool. Each subagent receives:

- Instructions from `agents/executor.md`
- Task definition (id, title, steps)
- Worktree path (e.g., `.worktrees/task-5/`)
- Architecture files reference

Example Agent call for one task:

```
Read agents/executor.md for your instructions.

=== MANDATORY FIRST STEPS ===
Before writing any code, you MUST:
1. Read <project-root>/AGENTS.md for project navigation
2. Read <project-root>/architecture.md for architecture constraints
3. If either file does not exist, pause and trigger architecture generation (see references/architecture-generation.md)
4. Read <project-root>/CLAUDE.md if it exists for project-specific instructions

=== YOUR TASK ===
- Task ID: 5
- Title: Add user profile page
- Steps:
  1. Create profile page component at src/app/profile/page.tsx
  2. Add user info display with avatar, name, email
  3. Implement edit mode with form
  4. Add save functionality with API call

=== YOUR ENVIRONMENT ===
- Worktree: .worktrees/task-5/
- Branch: feature/task-5
- Working directory: <project-root>

Read agents/executor.md first, follow the startup protocol, then implement the task.
```

**Spawn all executors in the same turn** so they run in parallel. Wait for all to complete before proceeding.

### Step 5: Handle Executor Results

For each executor result:

**If completed:**
- Note the changed files
- Proceed to verification

**If blocked:**
- Write blocking info to `progress.txt`
- Clean up worktree:
  ```bash
  git worktree remove .worktrees/task-<ID> --force
  git branch -D feature/task-<ID>
  ```
- Report blocker to user

**If only some executors completed:**
- Verify and merge the completed ones
- Handle blocked ones separately

### Step 6: Spawn Verifier Subagents

For each successfully completed task, spawn a verifier subagent. These also run in parallel:

```
Read agents/verifier.md for your instructions.

Your verification target:
- Task ID: 5
- Title: Add user profile page
- Steps: <task steps>
- Worktree path: .worktrees/task-5/
- Files changed: src/app/profile/page.tsx, src/components/user/ProfileForm.tsx

Working directory: <project-root>

Read agents/verifier.md first, then verify the implementation.
```

Wait for all verifiers to report back.

### Step 7: Merge or Rollback

Based on verifier verdicts:

**For PASS:**

```bash
# Copy worktree changes into main working tree
git merge feature/task-<ID> --no-edit

# Clean up worktree
git worktree remove .worktrees/task-<ID>
git branch -d feature/task-<ID>
```

**For FAIL or PARTIAL:**

```bash
# Discard the worktree — do NOT merge
git worktree remove .worktrees/task-<ID> --force
git branch -D feature/task-<ID>
```

Document the failure in `progress.txt` with verifier feedback.

**Merge order matters:** merge tasks one at a time. After each merge, check for conflicts. If a conflict occurs, resolve it manually before continuing to the next merge.

### Step 8: Document and Commit

Write progress entries to `progress.txt`:

```
## [YYYY-MM-DD] - Batch (Tasks #5, #7)

### Task #5: Add user profile page
- Executor: completed
- Verifier: PASS
- Files: src/app/profile/page.tsx, src/components/user/ProfileForm.tsx
- Notes: <any observations>

### Task #7: Add settings API
- Executor: completed
- Verifier: PASS
- Files: src/app/api/settings/route.ts
- Notes: <any observations>
```

Update `task.json` — change `passes` to `true` for all passed tasks.

Commit everything together:

```bash
git add .
git commit -m "batch: complete tasks #5, #7"
```

---

## Git Worktree Management

### Creating Worktrees

```bash
# Create a worktree with a new branch
git worktree add <worktree-path> -b <branch-name>

# Example
git worktree add .worktrees/task-5 -b feature/task-5
```

### Listing Worktrees

```bash
git worktree list
```

### Cleanup After Success

```bash
git worktree remove <worktree-path>
git branch -d <branch-name>
```

### Cleanup After Failure

```bash
# --force needed if worktree has uncommitted changes
git worktree remove <worktree-path> --force
git branch -D <branch-name>
```

### Pre-cleanup (before starting a new batch)

```bash
# Remove stale worktrees from previous interrupted sessions
git worktree prune
```

Always run `git worktree prune` before creating new worktrees to clean up any leftover state.

---

## Task JSON Structure

```json
{
  "project": "Project Name",
  "description": "Project description",
  "tasks": [
    {
      "id": 1,
      "title": "Task Title",
      "description": "What this task accomplishes",
      "steps": ["Step 1", "Step 2"],
      "passes": false,
      "priority": "high",
      "dependencies": [],
      "files": ["src/app/login/", "src/components/auth/"],
      "conflict_groups": ["ui"],
      "testing": "browser"
    }
  ]
}
```

**Field reference:**

| Field | Required | Description |
|-------|----------|-------------|
| `id` | yes | Unique task identifier |
| `title` | yes | Short task name |
| `description` | yes | What the task accomplishes |
| `steps` | yes | Ordered list of implementation steps |
| `passes` | yes | Whether task is complete (managed by orchestrator) |
| `priority` | no | `critical` / `high` / `medium` / `low` |
| `dependencies` | no | List of task IDs that must pass first |
| `files` | no | File paths this task will likely touch (used for conflict detection) |
| `conflict_groups` | no | Named groups — tasks sharing a group won't run in parallel |
| `testing` | no | `browser` if browser testing is required |

---

## Blocking Protocol

**When a task cannot be completed:**

The executor subagent reports `blocked`. The orchestrator:

1. Does NOT merge the worktree
2. Cleans up the worktree and branch
3. Writes to `progress.txt`:

```
## [Date] - Task #N: [Title] - BLOCKED

### Completed work:
- [What was done before blocking]

### Block reason:
- [Specific reason]

### Human action needed:
1. [Step 1]
2. [Step 2]
```

4. Reports to the user:
```
BLOCKED: Task #N - [Title]
Reason: [Why blocked]
Human action required:
1. [Step 1]
```

5. Other tasks in the same batch are NOT affected — they continue independently.

---

## Guardrails

1. **One Batch Per Turn** — Process one batch of parallel tasks, then report results
2. **Worktree Isolation** — Every executor works in its own worktree, never in the main tree
3. **Verify Before Merge** — Never merge a worktree until the verifier passes it
4. **Single Final Commit** — After all merges, commit task.json + progress.txt + code together
5. **No Task Deletion** — Only flip `passes: false` to `true`
6. **Block, Don't Fake** — When stuck, report and stop; don't mark as complete
7. **Clean Up Worktrees** — Always remove worktrees and branches after processing
8. **Merge One At A Time** — Merge worktree branches sequentially to handle conflicts
9. **Architecture First** — Ensure AGENTS.md and architecture.md exist before any task execution

---

## File Reference

### Required Project Files

| File | Purpose | Created By |
|------|---------|------------|
| `AGENTS.md` | Project navigation entry (~60-100 lines) | AI (via architecture generation) |
| `architecture.md` | Architecture constraints (tech stack, directory, constraints) | AI (via architecture generation) |
| `task.json` | Task definitions (source of truth) | Human |
| `progress.txt` | Session history and context | Orchestrator |
| `init.sh` | Environment setup script | Human |

### Skill Bundle Files

| File | Purpose |
|------|---------|
| `scripts/plan_batches.py` | Dependency analysis and batch grouping |
| `scripts/select_next_task.py` | Single-task selection (for non-parallel mode) |
| `scripts/validate_iteration.py` | Post-merge validation |
| `scripts/validate_architecture.py` | Architecture document validation |
| `agents/executor.md` | Execution subagent instructions |
| `agents/verifier.md` | Verification subagent instructions |
| `references/architecture-generation.md` | Guide for generating AGENTS.md and architecture.md |

**Templates available in `assets/templates/`:**
- `AGENTS.md` - Project navigation entry template
- `architecture.md` - Architecture doc template with required sections
- `task.json` - Task definition template (includes `files` and `conflict_groups` fields)
- `progress.txt` - Progress log template
- `init.sh` - Initialization script template

---

## Subcommands

| Subcommand | Action |
|------------|--------|
| `status` | Show task completion status and parallelizability |
| `next` | Execute next batch of parallelizable tasks |
| `init` | Run initialization script |
| `init-project` | Generate AGENTS.md and architecture.md for new project |
| `test` | Run lint and build verification |
| `run-all` | Execute all ready tasks across all batches |

---

## Examples

### Example 1: Parallel Batch Execution

```
User: continue

Orchestrator:
1. Runs plan_batches.py
2. Batch 1: Tasks #5 (profile page) and #7 (settings API) — no dependencies, no file overlap
3. Creates worktrees: .worktrees/task-5, .worktrees/task-7
4. Spawns executor subagents in parallel
5. Both complete successfully
6. Spawns verifier subagents in parallel
7. Task #5: PASS, Task #7: PASS
8. Merges feature/task-5, then feature/task-7
9. Updates task.json and progress.txt
10. Commits: "batch: complete tasks #5, #7"
```

### Example 2: Partial Failure

```
User: continue

Orchestrator:
1. Runs plan_batches.py
2. Batch 1: Tasks #3 and #6
3. Creates worktrees, spawns executors
4. Task #3: completed, Task #6: BLOCKED (missing API key)
5. Spawns verifier for #3 only
6. Task #3: PASS — merge and commit
7. Task #6: cleanup worktree, write blocker to progress.txt
8. Reports: "Task #3 done. Task #6 blocked — needs API key in .env.local"
```

### Example 3: Status Check

```
User: /coding-workflow status

Orchestrator output:
Project: Spring FES Video
Completed: 25/31 tasks
Remaining: 6 tasks
Ready for parallel execution: Tasks #27, #29 (no dependencies, no file overlap)
Waiting on dependencies: Tasks #28, #30, #31
Blocked: Task #26 (missing Supabase credentials)
```
