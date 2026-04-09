# task-driven-ai-dev

[![Validate Package](https://github.com/zhaohuanke123/task-driven-ai-dev/actions/workflows/validate.yml/badge.svg)](https://github.com/zhaohuanke123/task-driven-ai-dev/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)

Portable task-driven AI development harness for Codex, Claude Code, and Cursor.

This package extracts the reusable workflow from a real long-running AI-built project and turns it into a distribution-ready toolkit:

- Codex skill
- Claude Code subagent
- Cursor project rule
- reusable templates for `architecture.md`, `task.json`, `progress.txt`, and `project-config.json`
- helper scripts for task selection and iteration validation

## What Problem It Solves

Many AI coding loops degrade into:

- blind shell retries
- fake completion without real testing
- no durable progress memory
- no clear blocking protocol
- no clean handoff between planning and implementation

This package standardizes a safer loop:

1. Define architecture and constraints.
2. Track work in a machine-readable backlog.
3. Execute one task per guarded iteration.
4. Validate before claiming completion.
5. Record truthful progress.
6. Replace shell loops with explicit orchestration.

## Package Layout

- `codex-skill/task-driven-ai-dev/`: Codex-native skill package.
- `claude-agent/task-driven-ai-dev.md`: Claude Code subagent.
- `cursor-rule/task-driven-ai-dev.mdc`: Cursor rule file.
- `install.ps1`: Windows installer for all supported targets.
- `install.sh`: Unix-like installer for all supported targets.
- `project-config.json`: machine-readable config for this repository itself.

## Install

### Codex

User scope:

```powershell
./install.ps1 -Target codex
```

Project scope:

```powershell
./install.ps1 -Target codex -Mode project -Destination <repo-path>
```

Unix-like systems:

```bash
./install.sh --target codex
./install.sh --target codex --mode project --destination <repo-path>
```

### Claude Code

This package installs a Claude Code subagent because that is the stable official integration surface.

User scope:

```powershell
./install.ps1 -Target claude
```

Project scope:

```powershell
./install.ps1 -Target claude -Mode project -Destination <repo-path>
```

Unix-like systems:

```bash
./install.sh --target claude
./install.sh --target claude --mode project --destination <repo-path>
```

### Cursor

Cursor rule files are project-scoped:

```powershell
./install.ps1 -Target cursor -Mode project -Destination <repo-path>
```

```bash
./install.sh --target cursor --mode project --destination <repo-path>
```

## Included Artifacts

### Codex skill

- Main skill: [codex-skill/task-driven-ai-dev/SKILL.md](./codex-skill/task-driven-ai-dev/SKILL.md)
- UI metadata: [codex-skill/task-driven-ai-dev/agents/openai.yaml](./codex-skill/task-driven-ai-dev/agents/openai.yaml)

### References

- [workflow-contract.md](./codex-skill/task-driven-ai-dev/references/workflow-contract.md)
- [artifact-model.md](./codex-skill/task-driven-ai-dev/references/artifact-model.md)
- [subagent-orchestration.md](./codex-skill/task-driven-ai-dev/references/subagent-orchestration.md)
- [lessons-from-history.md](./codex-skill/task-driven-ai-dev/references/lessons-from-history.md)

### Templates

- [architecture.md](./codex-skill/task-driven-ai-dev/assets/templates/architecture.md)
- [task.json](./codex-skill/task-driven-ai-dev/assets/templates/task.json)
- [progress.txt](./codex-skill/task-driven-ai-dev/assets/templates/progress.txt)
- [project-config.json](./codex-skill/task-driven-ai-dev/assets/templates/project-config.json)

### Helper scripts

- [select_next_task.py](./codex-skill/task-driven-ai-dev/scripts/select_next_task.py)
- [validate_iteration.py](./codex-skill/task-driven-ai-dev/scripts/validate_iteration.py)

## Validation

This repository includes:

- [LICENSE](./LICENSE)
- [.gitattributes](./.gitattributes)
- [GitHub Actions validation workflow](./.github/workflows/validate.yml)

Local validation:

```powershell
python "C:\Users\zhk02\.codex\skills\.system\skill-creator\scripts\quick_validate.py" codex-skill/task-driven-ai-dev
python -m py_compile codex-skill/task-driven-ai-dev/scripts/select_next_task.py codex-skill/task-driven-ai-dev/scripts/validate_iteration.py
```

## Publish

This folder is already a standalone git repository. To push it to your own GitHub remote:

```powershell
git remote add origin <your-github-repo-url>
git push -u origin main
```

## Repo Config

The repository-level [project-config.json](./project-config.json) tells an agent:

- where the shipped artifacts live
- how to validate the package
- what kind of repository this is

## License

MIT. See [LICENSE](./LICENSE).
