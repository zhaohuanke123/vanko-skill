# [项目名] 导航

> 这是项目的导航入口。新对话时 AI 首先读取此文件，然后按需读取其他文件。

---

## 这是什么

[1-2 句话描述项目是什么，解决什么问题]

---

## 快速开始

新对话时，按顺序读取：

```
1. 本文件（AGENTS.md）     ← 导航入口（当前文件）
2. architecture.md         ← 架构约束（技术栈、目录、禁止事项）
3. task.json               ← 任务列表（要做什么）
4. progress.txt            ← 当前进度（已完成什么）
```

**按需读取**：
- 执行任务时 → `WORKFLOW.md`（工作流程指南）
- 项目特定指令 → `CLAUDE.md`（如存在）

---

## 文件导航

| 文件 | 用途 | 何时读取 |
|------|------|----------|
| [WORKFLOW.md](WORKFLOW.md) | 工作流程指南（Orchestrator） | 需要执行任务时 |
| [executor.md](executor.md) | Executor 子代理指令 | spawn executor 时 |
| [verifier.md](verifier.md) | Verifier 子代理指令 | spawn verifier 时 |
| [architecture.md](architecture.md) | 架构约束 | 编码前 |
| [task.json](task.json) | 任务定义 | 需要知道做什么时 |
| [progress.txt](progress.txt) | 开发历史 | 需要了解上下文时 |
| [CLAUDE.md](CLAUDE.md) | 项目特定指令 | 如存在则读取 |

---

## 目录结构

```
/
├── AGENTS.md              ← 本文件 - 导航入口
├── WORKFLOW.md            ← 工作流程指南
├── architecture.md        ← 架构约束
├── task.json              ← 任务定义
├── progress.txt           ← 开发历史
├── CLAUDE.md              ← 项目特定指令（可选）
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

---

## 下一步

- **了解架构** → 读取 [architecture.md](architecture.md)
- **查看任务** → 读取 [task.json](task.json)
- **执行开发** → 读取 [WORKFLOW.md](WORKFLOW.md)
- **查看进度** → 读取 [progress.txt](progress.txt)