# [项目名]

[1-2 句话描述项目是什么，解决什么问题]

---

## 开发流程

本项目使用 Harness Engineering 架构，文档先行作为运行时门禁。

### 新对话读取顺序

```
1. 本文件（CLAUDE.md）    ← 项目配置和导航入口（当前文件）
2. PROJECT.md             ← 当前阶段、版本、恢复上下文（如存在）
3. WORKFLOW.md            ← 工作流程和 Documentation Gate
4. task.json              ← 任务列表、依赖、文档引用
5. progress.txt           ← 当前进度、测试证据、跳过文档记录
6. 任务相关 docs/*        ← 需求、设计、架构
7. 源码和测试             ← 仅在 Documentation Gate 通过后读取和修改
```

### Documentation Gate

任何 bug、功能、行为变更都不能直接改源码。编码前必须：

1. 读取 `PROJECT.md`（如存在）、`WORKFLOW.md`、`task.json` 和 `progress.txt`。
2. 找到当前任务的 `requirement_ref` 和 `design_ref`，或定位对应的 `docs/*` 章节。
3. 如果文档已定义正确行为但代码不符，先在 `progress.txt` 记录实现 bug，再修代码。
4. 如果用户请求的是新行为或变更，先更新需求/设计/架构文档，再修代码。
5. 如果用户明确确认跳过文档，必须在 `PROJECT.md` 或 `progress.txt` 记录跳过原因、风险和待补文档。

任务只有在 docs/code/tests 一致后才能标记完成。

---

## Memory 规则

Memory 只能提醒 agent 读取本文件，不能替代项目状态文件。

如果 memory 与项目文件冲突，按以下优先级处理：

```text
用户最新明确指令
> PROJECT.md / docs/* / task.json / progress.txt
> CLAUDE.md / WORKFLOW.md
> skill instructions
> memory hints
```

冲突示例：
- memory 说任务完成，但 `task.json` 未完成 → 任务未完成。
- memory 说可以直接改源码，但 `WORKFLOW.md` 要求 Documentation Gate → 先过 gate。
- memory 记得旧设计，但 `docs/design.md` 已更新 → 以 `docs/design.md` 为准。

---

## 文件导航

| 文件 | 用途 | 何时读取 |
|------|------|----------|
| [WORKFLOW.md](WORKFLOW.md) | 工作流程指南（Orchestrator） | 需要执行任务时 |
| [executor.md](executor.md) | Executor 子代理指令 | spawn executor 时 |
| [verifier.md](verifier.md) | Verifier 子代理指令 | spawn verifier 时 |
| [PROJECT.md](PROJECT.md) | 项目阶段、版本、恢复上下文 | 新对话和执行前 |
| [docs/requirements.md](docs/requirements.md) | 行为和范围要求 | 需求、bug、行为变更 |
| [docs/design.md](docs/design.md) | 模块设计和接口契约 | 编码前 |
| [docs/architecture.md](docs/architecture.md) | 系统架构和数据流 | 架构相关变更 |
| [architecture.md](architecture.md) | 架构约束 | 编码前 |
| [task.json](task.json) | 任务定义、依赖、文档引用 | 需要知道做什么时 |
| [progress.txt](progress.txt) | 开发历史、文档更新、测试证据 | 需要了解上下文时 |

---

## 目录结构

```
/
├── CLAUDE.md              ← 本文件 - 项目配置和导航入口
├── WORKFLOW.md            ← 工作流程指南和 Documentation Gate
├── PROJECT.md             ← 项目状态（如存在）
├── docs/                  ← 生命周期文档（如存在）
│   ├── requirements.md    ← 行为和范围要求
│   ├── design.md          ← 模块设计和接口契约
│   └── architecture.md    ← 系统架构和数据流
├── architecture.md        ← 架构约束
├── task.json              ← 任务定义与文档引用
├── progress.txt           ← 开发历史、文档更新、测试证据
├── src/
│   ├── app/               ← [职责说明]
│   ├── components/        ← [职责说明]
│   ├── lib/               ← [职责说明]
│   └── types/             ← [职责说明]
└── public/                ← 静态资源
```

---

## 关键约定

### 命名规范

- [文件命名规范，如：组件使用 PascalCase.tsx]
- [目录命名规范，如：路由目录使用 kebab-case]

### 禁止事项

从 `architecture.md` 的 Key Constraints 章节提取：
- [禁止事项1]
- [禁止事项2]
