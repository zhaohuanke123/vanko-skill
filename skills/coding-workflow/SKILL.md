---
name: coding-workflow
description: |
  A structured development workflow for fullstack projects. Use this skill when you need to implement features systematically, track progress across sessions, and maintain code quality through testing.
  TRIGGER when: user wants to work on tasks from task.json; user asks to continue development; user mentions "next task" or "coding workflow"; project has task.json file.
  DO NOT TRIGGER when: no task.json exists; user asks for a single quick fix without structured workflow.
license: Apache-2.0
---

# Coding Workflow

A disciplined workflow for implementing fullstack features with verification gates and persistent state.

## Quick Start

1. **Initialize**: Run `./init.sh` to install dependencies and start dev server
2. **Select Task**: Read `task.json`, find first task with `passes: false`
3. **Implement**: Follow task steps, use existing code patterns
4. **Test**: Run lint/build, test in browser for UI changes
5. **Document**: Write to `progress.txt`
6. **Commit**: Submit all changes in single commit

---

## Operation Modes

### Mode 1: Continue (Default)

When user says "continue", "next task", or invokes without arguments:

1. Read `task.json` from project root
2. Find first task where `passes: false`
3. Implement following the workflow below
4. Stop after ONE task completion or blockage

### Mode 2: Specific Task

When user specifies a task ID or description:

1. Locate the specific task in `task.json`
2. Implement if `passes: false`
3. If already `passes: true`, ask for confirmation to re-implement

### Mode 3: Status

When user asks for status or progress:

1. Read `task.json`
2. Summarize completed vs remaining tasks
3. Show current blocking issues from `progress.txt`

---

## Core Workflow

### Step 1: Environment Initialization

**Required at session start:**

```bash
./init.sh
```

This script should:
- Install all npm/pip dependencies
- Start development server
- Verify environment is ready

**If `init.sh` does not exist:**
- Check for `package.json` and run `npm install`
- Start dev server with appropriate command (`npm run dev`, etc.)

### Step 2: Task Selection

**Use the helper script for deterministic selection:**

```bash
python scripts/select_next_task.py --task-file task.json
```

Or manually read `task.json` and select based on:

1. **Priority 1**: Tasks with `passes: false` (not completed)
2. **Priority 2**: Consider dependency order (fundamental features first)
3. **Priority 3**: Respect explicit priority field if present

**Task JSON Structure:**

```json
{
  "project": "Project Name",
  "description": "Project description",
  "tasks": [
    {
      "id": 1,
      "title": "Task Title",
      "description": "What this task accomplishes",
      "steps": ["Step 1", "Step 2", "..."],
      "passes": false,
      "priority": "high"
    }
  ]
}
```

### Step 3: Implementation

**Before writing code:**

1. Read relevant existing code to understand patterns
2. Check `architecture.md` for design decisions
3. Review `progress.txt` for context from previous sessions

**During implementation:**

1. Follow existing code conventions (TypeScript strict mode, functional components, etc.)
2. Implement all steps listed in the task
3. Keep changes minimal and focused on the task
4. Do NOT modify unrelated code

**Code conventions to follow:**

- TypeScript strict mode enabled
- Functional components with hooks (React)
- Tailwind CSS for styling
- Server Components by default (Next.js App Router)
- Client Components only when needed ('use client')

### Step 4: Testing & Verification

**Testing Requirements (MANDATORY):**

| Change Type | Testing Required |
|------------|------------------|
| New page / major UI rewrite | Browser test with MCP Playwright |
| Component modification | Browser test or visual verification |
| API endpoint | curl test or browser test |
| Utility function / bug fix | Unit test or lint/build verification |
| Style changes | Browser test recommended |

**All changes must pass:**

```bash
# In project directory
npm run lint    # No errors
npm run build   # Build succeeds
```

**Browser Testing with MCP Playwright:**

```
1. Navigate to relevant page
2. Verify page loads without errors
3. Test interactive elements (buttons, forms)
4. Take screenshot to confirm UI
```

**Testing Checklist:**

- [ ] No TypeScript errors
- [ ] lint passes
- [ ] build succeeds
- [ ] Functionality verified in browser (for UI changes)

### Step 5: Progress Documentation

Write to `progress.txt` in this format:

```
## [YYYY-MM-DD] - Task #N: [Task Title]

### What was done:
- [Specific implementation details]
- [Files created/modified]

### Testing:
- [How tested]
- [Results]

### Notes:
- [Context for future agents]
- [Any decisions made]
```

### Step 6: Validate & Commit

**Run validation before commit:**

```bash
python scripts/validate_iteration.py --task-id N --project-dir .
```

This verifies:
- Task is marked in progress
- Progress entry exists
- Lint and build pass

**All changes in ONE commit:**

```bash
# 1. Update task.json: change passes to true
# 2. Update progress.txt with work done
# 3. Stage all changes
git add .

# 4. Commit with descriptive message
git commit -m "[Task Title] - completed"
```

**Commit rules:**
- Only mark `passes: true` after ALL steps verified
- Never remove or delete tasks from task.json
- Never modify task descriptions
- Include code, progress.txt, task.json in same commit

---

## Task Failure & Rollback

**If implementation fails after partial changes:**

### Step 1: Check Current State

```bash
git status           # See modified files
git diff             # Review changes
```

### Step 2: Rollback if Needed

```bash
# Discard all uncommitted changes
git restore .

# Or discard specific files
git restore path/to/file.ts
```

### Step 3: Document Failure

Write to `progress.txt`:

```
## [YYYY-MM-DD] - Task #N: [Title] - FAILED

### What was attempted:
- [What was tried]

### Failure reason:
- [Specific error or issue]

### Rollback:
- [What was reverted]

### Next steps:
- [What needs to happen before retry]
```

### Step 4: Task Remains Incomplete

- Do NOT mark `passes: true`
- Do NOT commit partial work
- Task stays `passes: false` for next session

---

## Blocking Protocol

**When you CANNOT complete a task:**

### Blocking Scenarios

1. **Missing Configuration**
   - .env files need real API keys
   - Database not set up
   - External service not configured

2. **External Dependencies**
   - Third-party API down
   - OAuth requiring human authorization
   - Paid service upgrade needed

3. **Testing Impossible**
   - Need real user account
   - Hardware requirements not met
   - External system not deployed

### Required Actions

**DO NOT:**
- Submit any git commit
- Mark task as `passes: true`
- Pretend task is complete

**MUST:**

1. Document in `progress.txt`:
   ```
   ## [Date] - Task #N: [Title] - BLOCKED

   ### Completed work:
   - [What was done before blocking]

   ### Block reason:
   - [Specific reason]

   ### Human action needed:
   1. [Specific step 1]
   2. [Specific step 2]

   ### Resume command:
   - [Command to run after unblocking]
   ```

2. Output blocking message to user:
   ```
   BLOCKING: Task #N - [Title]

   Reason: [Why blocked]

   Human action required:
   1. [Step 1]
   2. [Step 2]

   Run this after unblocking: [command]
   ```

3. STOP and wait for human intervention

---

## Guardrails

### Inviolable Rules

1. **One Task Per Session** - Complete only one task, then stop
2. **Test Before Mark** - Never mark complete without verification
3. **Single Commit** - All changes (code, progress, task.json) together
4. **No Task Deletion** - Only flip `passes: false` to `true`
5. **Browser Test UI** - Major UI changes require browser verification
6. **Block, Don't Fake** - When stuck, document and stop

### Common Pitfalls

- **Don't skip testing** - Even "obvious" changes can break things
- **Don't modify unrelated code** - Stay focused on the task
- **Don't guess conventions** - Read existing code for patterns
- **Don't ignore build errors** - Fix before marking complete
- **Don't commit partial work** - Complete the task or block

---

## File Reference

### Required Project Files

| File | Purpose | Created By |
|------|---------|------------|
| `task.json` | Task definitions (source of truth) | Human |
| `progress.txt` | Session history and context | Agent |
| `architecture.md` | System design decisions | Human |
| `init.sh` | Environment setup script | Human (use template) |
| `CLAUDE.md` | Project-specific instructions | Human |

**Templates available in `assets/templates/`:**
- `task.json` - Task definition template
- `progress.txt` - Progress log template
- `architecture.md` - Architecture doc template
- `project-config.json` - Project config template
- `init.sh` - Initialization script template

### Optional Files

| File | Purpose |
|------|---------|
| `project-config.json` | Additional configuration |
| `.env.local.example` | Environment template |
| `supabase/migrations/` | Database migrations |

---

## Integration with MCP Playwright

For browser testing, use MCP Playwright tools:

```
1. browser_navigate: Go to page URL
2. browser_snapshot: Get page accessibility tree
3. browser_click: Click elements
4. browser_type: Fill forms
5. browser_take_screenshot: Capture visual state
```

**When to use browser testing:**
- Creating new pages
- Major component rewrites
- Form submissions
- Interactive features
- Visual styling changes

---

## Subcommands

| Subcommand | Action |
|------------|--------|
| `status` | Show task completion status |
| `next` | Continue to next incomplete task |
| `init` | Run initialization script |
| `test` | Run lint and build verification |

---

## Examples

### Example 1: Continue Development

```
User: continue

Agent actions:
1. Read task.json
2. Find task #5 with passes: false
3. Implement all steps
4. Test with npm run lint && npm run build
5. Write to progress.txt
6. Commit with task.json updated
```

### Example 2: Blocked Task

```
User: next task

Agent actions:
1. Read task.json
2. Find task #8 with passes: false
3. Attempt implementation
4. Discover missing API key
5. Write blocking info to progress.txt
6. Output blocking message
7. STOP (no commit)
```

### Example 3: Status Check

```
User: /coding-workflow status

Agent output:
Project: Spring FES Video
Completed: 25/31 tasks
Remaining: 6 tasks
Current: Task #26 (Video generation stage UI)
Blocking: None
```
