# ── docker-run.ps1 ────────────────────────────────────────────────────────────
# Builds (once) and starts the ls-devs/nvim Docker container on Windows.
#
# Requirements:
#   - Docker Desktop for Windows (https://www.docker.com/products/docker-desktop)
#   - PowerShell 5.1+ (built-in on Windows 10/11)
#
# Usage:
#   .\docker-run.ps1                → open Neovim in the current directory
#   .\docker-run.ps1 zsh            → drop into zsh (spaceship + oh-my-zsh)
#   .\docker-run.ps1 bash           → drop into bash (fallback)
#   .\docker-run.ps1 nvim myfile    → open a specific file
#
# Host filesystem is mounted so you can edit any Windows file:
#   nvim /mnt/c/Users/YourName/projects/myapp/src/main.ts
#
# GitHub CLI auth is forwarded so Copilot works without re-login.
# ─────────────────────────────────────────────────────────────────────────────

param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Command = @("nvim")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$image     = "ls-devs-nvim:latest"
$scriptDir = $PSScriptRoot
# Repo root is the parent of setup/
$repoDir   = Split-Path $scriptDir -Parent

# ── Build if the image doesn't exist ─────────────────────────────────────────
$imageExists = (docker images -q $image 2>$null) -ne ""
if (-not $imageExists) {
    Write-Host "[INFO]  Image '$image' not found — building now (this takes ~10 min on first run)..." -ForegroundColor Cyan
    # Use repo root as build context so `COPY . /root/.config/nvim/` copies the full config
    docker build -t $image -f "$scriptDir\Dockerfile" $repoDir
    Write-Host "[INFO]  Build complete." -ForegroundColor Cyan
}

# ── Mounts ────────────────────────────────────────────────────────────────────
$mounts = @(
    # Working directory → /workspace (primary editing area)
    "-v", "${PWD}:/workspace",

    # Windows C drive → /mnt/c  (access to the whole Windows filesystem)
    # Add more drives as needed: "-v", "D:\:/mnt/d"
    "-v", "C:\:/mnt/c"
)

# GitHub CLI auth — forwards existing gh login so Copilot works without re-auth
$ghConfigPath = "$env:USERPROFILE\.config\gh"
if (Test-Path $ghConfigPath) {
    $mounts += @("-v", "${ghConfigPath}:/root/.config/gh")
}

# SSH keys (read-only — for git over SSH)
$sshPath = "$env:USERPROFILE\.ssh"
if (Test-Path $sshPath) {
    $mounts += @("-v", "${sshPath}:/root/.ssh:ro")
}

# Git global config (read-only)
$gitconfigPath = "$env:USERPROFILE\.gitconfig"
if (Test-Path $gitconfigPath) {
    $mounts += @("-v", "${gitconfigPath}:/root/.gitconfig:ro")
}

# ── Run ───────────────────────────────────────────────────────────────────────
$dockerArgs = @(
    "run", "-it", "--rm"
) + $mounts + @(
    "-w", "/workspace",
    "-e", "TERM=xterm-256color",
    "-e", "COLORTERM=truecolor",
    $image
) + $Command

& docker @dockerArgs
