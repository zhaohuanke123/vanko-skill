param(
    [ValidateSet("codex", "claude", "cursor")]
    [string]$Target,
    [ValidateSet("user", "project")]
    [string]$Mode = "user",
    [string]$Destination = "",
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$packageRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Ensure-Directory([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Copy-PackageDirectory([string]$Source, [string]$TargetPath) {
    if (Test-Path -LiteralPath $TargetPath) {
        if (-not $Force) {
            throw "Target already exists: $TargetPath. Re-run with -Force to overwrite."
        }
        Remove-Item -LiteralPath $TargetPath -Recurse -Force
    }
    Copy-Item -LiteralPath $Source -Destination $TargetPath -Recurse -Force
}

function Resolve-ProjectRoot([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) {
        return (Get-Location).Path
    }
    return (Resolve-Path -LiteralPath $Path).Path
}

switch ($Target) {
    "codex" {
        $source = Join-Path $packageRoot "codex-skill\task-driven-ai-dev"
        if ($Mode -eq "user") {
            $baseDir = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
            $targetDir = Join-Path $baseDir "skills"
        } else {
            $projectRoot = Resolve-ProjectRoot $Destination
            $targetDir = Join-Path $projectRoot ".codex\skills"
        }
        Ensure-Directory $targetDir
        Copy-PackageDirectory $source (Join-Path $targetDir "task-driven-ai-dev")
        Write-Host "Installed Codex skill to $targetDir"
    }
    "claude" {
        $source = Join-Path $packageRoot "claude-agent\task-driven-ai-dev.md"
        if ($Mode -eq "user") {
            $targetDir = Join-Path $HOME ".claude\agents"
        } else {
            $projectRoot = Resolve-ProjectRoot $Destination
            $targetDir = Join-Path $projectRoot ".claude\agents"
        }
        Ensure-Directory $targetDir
        Copy-Item -LiteralPath $source -Destination (Join-Path $targetDir "task-driven-ai-dev.md") -Force
        Write-Host "Installed Claude Code subagent to $targetDir"
    }
    "cursor" {
        if ($Mode -eq "user") {
            throw "Cursor file-based rules are project-scoped. Use -Mode project -Destination <repo-path>."
        }
        $projectRoot = Resolve-ProjectRoot $Destination
        $targetDir = Join-Path $projectRoot ".cursor\rules"
        $source = Join-Path $packageRoot "cursor-rule\task-driven-ai-dev.mdc"
        Ensure-Directory $targetDir
        Copy-Item -LiteralPath $source -Destination (Join-Path $targetDir "task-driven-ai-dev.mdc") -Force
        Write-Host "Installed Cursor rule to $targetDir"
    }
}
