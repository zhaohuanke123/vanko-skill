#!/usr/bin/env bash

set -euo pipefail

target=""
mode="user"
destination=""
force="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      target="$2"
      shift 2
      ;;
    --mode)
      mode="$2"
      shift 2
      ;;
    --destination)
      destination="$2"
      shift 2
      ;;
    --force)
      force="true"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$target" ]]; then
  echo "Usage: ./install.sh --target codex|claude|cursor [--mode user|project] [--destination path] [--force]" >&2
  exit 1
fi

package_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ensure_dir() {
  mkdir -p "$1"
}

copy_dir() {
  local source="$1"
  local target_path="$2"
  if [[ -e "$target_path" ]]; then
    if [[ "$force" != "true" ]]; then
      echo "Target already exists: $target_path. Re-run with --force to overwrite." >&2
      exit 1
    fi
    rm -rf "$target_path"
  fi
  cp -R "$source" "$target_path"
}

resolve_project_root() {
  if [[ -z "$destination" ]]; then
    pwd
  else
    cd "$destination" && pwd
  fi
}

case "$target" in
  codex)
    source="$package_root/codex-skill/task-driven-ai-dev"
    if [[ "$mode" == "user" ]]; then
      base_dir="${CODEX_HOME:-$HOME/.codex}"
      target_dir="$base_dir/skills"
    else
      project_root="$(resolve_project_root)"
      target_dir="$project_root/.codex/skills"
    fi
    ensure_dir "$target_dir"
    copy_dir "$source" "$target_dir/task-driven-ai-dev"
    echo "Installed Codex skill to $target_dir"
    ;;
  claude)
    source="$package_root/claude-agent/task-driven-ai-dev.md"
    if [[ "$mode" == "user" ]]; then
      target_dir="$HOME/.claude/agents"
    else
      project_root="$(resolve_project_root)"
      target_dir="$project_root/.claude/agents"
    fi
    ensure_dir "$target_dir"
    cp "$source" "$target_dir/task-driven-ai-dev.md"
    echo "Installed Claude Code subagent to $target_dir"
    ;;
  cursor)
    if [[ "$mode" == "user" ]]; then
      echo "Cursor file-based rules are project-scoped. Use --mode project --destination <repo-path>." >&2
      exit 1
    fi
    project_root="$(resolve_project_root)"
    target_dir="$project_root/.cursor/rules"
    ensure_dir "$target_dir"
    cp "$package_root/cursor-rule/task-driven-ai-dev.mdc" "$target_dir/task-driven-ai-dev.mdc"
    echo "Installed Cursor rule to $target_dir"
    ;;
  *)
    echo "Unsupported target: $target" >&2
    exit 1
    ;;
esac
