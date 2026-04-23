# Workflow Contract

This document defines the contract between human developers and the multi-agent coding-workflow system.

## Agent Roles

### Orchestrator (Main Agent)

The central coordinator that manages the entire workflow:

- Reads and analyzes task.json dependency graph
- Groups parallelizable tasks into batches using `plan_batches.py`
- Creates git worktrees for task isolation
- Spawns executor and verifier subagents
- Merges successful worktree branches back to main
- Manages task.json state and progress documentation
- Handles blocking situations and reports to human

### Executor Subagent

Implements a single task in an isolated worktree:

- Works only in the assigned worktree directory
- Follows project code conventions
- Completes all steps listed in the task
- Commits implementation to worktree branch
- Reports completion status or blockers

### Verifier Subagent

Independently validates an executor's output:

- Reviews code changes for correctness and completeness
- Runs lint and build in the worktree
- Performs browser testing when required
- Does NOT modify any files
- Returns PASS / FAIL / PARTIAL verdict

## Agent Responsibilities

### 1. Task Execution

- Each task is executed by one dedicated executor subagent
- Executors work in isolated git worktrees (no cross-contamination)
- Implementation follows existing code patterns and conventions
- Changes stay focused on the assigned task only

### 2. Testing & Verification

- Verification is done by a separate verifier subagent (not the executor)
- Lint and build must pass in the worktree before merge
- Browser testing is mandatory for tasks with `"testing": "browser"`
- Verification is a read-only operation — verifiers never modify files

### 3. State Management

- Only the orchestrator updates task.json and progress.txt
- task.json is updated after successful merge (not before)
- progress.txt documents batch results, not individual subagent logs
- All state changes are committed together in one commit per batch

### 4. Blocking Behavior

- Executor detects blocking conditions and reports to orchestrator
- Blocked tasks do not affect other tasks in the same batch
- Orchestrator cleans up blocked worktrees and branches
- Human receives actionable steps to unblock

## Human Responsibilities

### 1. Task Definition

- Provide clear, actionable task descriptions
- Break large features into smaller independent tasks
- Specify dependencies between tasks accurately
- Declare `files` and `conflict_groups` for parallel safety
- Define acceptance criteria in steps

### 2. Environment Setup

- Provide working init.sh script
- Document required environment variables
- Ensure external services are accessible
- Provide test credentials if needed

### 3. Review & Unblock

- Review batch results after each orchestrator turn
- Provide missing configuration for blocked tasks
- Resolve merge conflicts if they arise
- Validate completed work

## State Transitions

```
[Task States]

passes: false → SELECTED FOR BATCH
                ↓
        Worktree Created
                ↓
        Executor Spawned → COMPLETED / BLOCKED
                ↓ (completed)
        Verifier Spawned → PASS / FAIL / PARTIAL
                ↓ (pass)
        Branch Merged → passes: true → COMMITTED

        ↓ (blocked)         ↓ (fail)
        Worktree cleaned    Worktree cleaned
        Human notified      Verifier feedback to progress.txt
        Task stays false    Task stays false

        ↓ (partial)
        Similar to fail — specific steps flagged for retry
```

## Parallel Safety Rules

1. Tasks with mutual dependencies are NEVER in the same batch
2. Tasks sharing `conflict_groups` are NEVER in the same batch
3. Tasks with overlapping `files` paths are NEVER in the same batch
4. Merges happen one at a time to handle conflicts properly
5. A blocked task does not block its batch-mates

## Success Criteria

A task is successfully completed when:

1. Executor implemented all steps
2. Code follows existing patterns
3. Verifier confirmed completeness and correctness
4. Lint passes with no errors
5. Build succeeds
6. Browser test passed (if applicable)
7. Worktree merged into main branch
8. Progress documented in progress.txt
9. Task marked `passes: true`
10. All changes committed together
