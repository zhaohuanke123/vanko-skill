# Workflow Contract

This document defines the contract between human developers and AI agents using the coding-workflow skill.

## Agent Responsibilities

### 1. Task Execution

- Read and understand task requirements fully before implementation
- Implement all steps listed in the task
- Follow existing code patterns and conventions
- Keep changes minimal and focused

### 2. Testing & Verification

- Run lint and build after every change
- Test UI changes in browser
- Verify all steps are complete before marking done
- Document how testing was performed

### 3. State Management

- Update progress.txt with work done
- Update task.json with passes status
- Maintain commit atomicity

### 4. Blocking Behavior

- Detect blocking conditions early
- Document blocking clearly
- Do not commit blocked work
- Provide actionable steps for humans

## Human Responsibilities

### 1. Task Definition

- Provide clear, actionable task descriptions
- Break large features into smaller tasks
- Specify dependencies between tasks
- Define acceptance criteria

### 2. Environment Setup

- Provide working init.sh script
- Document required environment variables
- Ensure external services are accessible
- Provide test credentials if needed

### 3. Review & Unblock

- Review agent output
- Provide missing configuration
- Unblock agents when ready
- Validate completed work

## State Transitions

```
[Task States]

passes: false → IN PROGRESS
                ↓
        Implementation Complete
                ↓
        Testing Passed → passes: true
                ↓
           COMMITTED

        Testing Failed → passes: false
                ↓
           FIX & RETRY

        Blocked → passes: false
                ↓
           DOCUMENT & STOP
```

## Success Criteria

A task is successfully completed when:

1. All steps are implemented
2. Code follows existing patterns
3. Lint passes with no errors
4. Build succeeds
5. UI tested in browser (if applicable)
6. Progress documented in progress.txt
7. Task marked passes: true
8. All changes committed together
