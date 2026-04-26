# Development Workflow

完整工作流程指南，AI 自驱动开发时遵循此流程。

---

## 多代理架构

```
Orchestrator（主代理）
  ├── 读取 task.json，分析依赖图
  ├── 创建 git worktrees 用于并行任务
  ├── spawn Executor 子代理（一个任务一个，并行执行）
  ├── spawn Verifier 子代理（一个任务一个，并行验证）
  ├── 合并 worktree 分支回 main
  └── 提交 task.json + progress.txt 更新
```

**三种角色**：
- **Orchestrator** — 协调批次、管理 worktrees、合并结果
- **Executor** — 在隔离 worktree 中实现单个任务
- **Verifier** — 独立审查和测试 executor 的输出

---

## 工作模式

### Mode 1: Continue（默认）

当用户说 "继续"、"下一个任务"、"开发"：

1. 读取 `task.json` 获取任务列表
2. 读取 `progress.txt` 了解当前进度
3. 运行依赖分析选择可执行任务
4. 执行任务（见下方执行流程）

### Mode 2: Status

当用户说 "状态"、"进度"：

1. 读取 `task.json` 和 `progress.txt`
2. 汇报：已完成/剩余/阻塞的任务
3. 显示哪些任务可并行执行

### Mode 3: Specific Task

当用户指定任务 ID 或描述：

1. 在 `task.json` 中定位任务
2. 作为单任务批次执行

---

## Orchestrator 执行流程

### Step 1: 架构约束检查

**编码前必须读取**：

```
1. architecture.md - 获取技术栈、目录结构、禁止事项
2. 确认理解关键约束
```

从 `architecture.md` 提取：

| 约束类型 | 章节 | 确认内容 |
|----------|------|----------|
| 技术栈 | `## Tech Stack` | 框架、语言、库 |
| 目录结构 | `## Directory Structure` | 代码放置位置 |
| 禁止事项 | `## Key Constraints` | 什么不能做 |

### Step 2: 任务选择

使用依赖分析：

```bash
python scripts/plan_batches.py --task-file task.json --format json
```

选择规则：
- 所有依赖任务必须已完成（`passes: true`）
- 同批次任务无文件冲突
- 同批次任务无 `conflict_groups` 冲突

### Step 3: Worktree 创建

为每个任务创建隔离工作树：

```bash
git worktree add .worktrees/task-<ID> -b feature/task-<ID>
```

### Step 4: Spawn Executor 子代理

为每个任务 spawn 一个 executor 子代理，**所有 executor 并行运行**。

**Executor 提示模板**：

```
读取 executor.md 获取你的指令。

=== 必须首先执行 ===
1. 读取 architecture.md 获取架构约束
2. 如果 architecture.md 不存在，报告 BLOCKED

=== 你的任务 ===
- Task ID: <id>
- Title: <title>
- Steps:
  <步骤列表>

=== 你的环境 ===
- Worktree: .worktrees/task-<id>/
- Branch: feature/task-<id>

读取 executor.md 后，按启动协议执行任务。
```

### Step 5: 处理 Executor 结果

**如果 completed**：
- 记录变更文件
- 进入验证阶段

**如果 blocked**：
- 写入 `progress.txt` 阻塞信息
- 清理 worktree：
  ```bash
  git worktree remove .worktrees/task-<ID> --force
  git branch -D feature/task-<ID>
  ```
- 报告阻塞给用户

### Step 6: Spawn Verifier 子代理

为每个完成的任务 spawn 一个 verifier 子代理，**所有 verifier 并行运行**。

**Verifier 提示模板**：

```
读取 verifier.md 获取你的指令。

=== 验证目标 ===
- Task ID: <id>
- Title: <title>
- Steps: <步骤列表>
- Worktree: .worktrees/task-<id>/
- Files changed: <文件列表>

读取 verifier.md 后，按验证流程检查实现。
```

### Step 7: 处理 Verifier 结果

**如果 PASS**：
- 合并 worktree
- 更新 task.json 和 progress.txt

**如果 FAIL 或 PARTIAL**：
- 记录失败原因到 progress.txt
- 清理 worktree（不合并）

### Step 8: 合并或回滚

**验证通过**：

```bash
git merge feature/task-<ID> --no-edit
git worktree remove .worktrees/task-<ID>
git branch -d feature/task-<ID>
```

**验证失败**：

```bash
git worktree remove .worktrees/task-<ID> --force
git branch -D feature/task-<ID>
```

记录失败原因到 `progress.txt`。

### Step 9: 记录和提交

更新 `progress.txt`：

```
## [YYYY-MM-DD] - Task #N: [Title]

### What was done:
- [变更列表]

### Testing:
- [测试结果]

### Notes:
- [备注]
```

更新 `task.json`：将 `passes` 改为 `true`

提交：

```bash
git add .
git commit -m "complete task #N: [Title]"
```

---

## 阻塞处理

当任务无法完成：

1. **不合并** worktree
2. 清理 worktree 和分支
3. 写入 `progress.txt`：

```
## [YYYY-MM-DD] - Task #N: [Title] - BLOCKED

### Block reason:
- [具体原因]

### Human action needed:
1. [步骤1]
2. [步骤2]
```

4. 报告给用户

---

## Guardrails

1. **架构优先** - 编码前必须读取 `architecture.md`
2. **Worktree 隔离** - 每个任务在独立 worktree 中执行
3. **验证先于合并** - 验证通过才能合并
4. **单批次执行** - 每次处理一个批次，汇报结果
5. **阻塞不伪造** - 无法完成时报告阻塞，不标记完成
6. **清理 Worktree** - 完成后移除 worktree 和分支
7. **并行执行** - 同批次任务的 executor 和 verifier 并行运行

---

## 子代理指令文件

| 文件 | 用途 |
|------|------|
| `executor.md` | Executor 子代理指令 |
| `verifier.md` | Verifier 子代理指令 |

---

## 脚本工具

| 脚本 | 用途 |
|------|------|
| `scripts/plan_batches.py` | 分析依赖，输出并行批次 |
| `scripts/validate_iteration.py` | 验证迭代一致性 |
| `scripts/validate_architecture.py` | 验证架构文档完整性 |