#!/usr/bin/env bash
# ── docker-run.sh ─────────────────────────────────────────────────────────────
# Builds (once) and starts the ls-devs/nvim Docker container.
# Works on Linux and macOS.
#
# Usage:
#   ./docker-run.sh              → open Neovim in the current directory
#   ./docker-run.sh zsh          → drop into zsh (spaceship + oh-my-zsh)
#   ./docker-run.sh bash         → drop into bash (fallback)
#   ./docker-run.sh nvim myfile  → open a specific file
#
# Host filesystem is mounted at /mnt/host so you can edit any file:
#   nvim /mnt/host/home/<you>/projects/myapp/src/main.ts
#
# GitHub CLI auth (~/.config/gh) is forwarded so Copilot works immediately.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

IMAGE="ls-devs-nvim:latest"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Helpers ───────────────────────────────────────────────────────────────────
info() { echo -e "\033[0;34m[INFO]\033[0m  $*"; }

# Repo root is the parent of this script's directory (setup/)
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# ── Build if the image doesn't exist ─────────────────────────────────────────
if ! docker image inspect "$IMAGE" &>/dev/null; then
  info "Image '${IMAGE}' not found — building now (this takes ~10 min on first run)…"
  # Use repo root as build context so `COPY . /root/.config/nvim/` copies the full config
  docker build -t "$IMAGE" -f "${SCRIPT_DIR}/Dockerfile" "$REPO_DIR"
  info "Build complete."
fi

# ── Mounts ────────────────────────────────────────────────────────────────────
MOUNTS=()

# Working directory → /workspace (primary editing area inside the container)
MOUNTS+=(-v "$(pwd):/workspace")

# Full host filesystem (read-write access to the whole computer)
case "$(uname -s)" in
  Linux)
    # On Linux, Docker shares the kernel so we can mount / directly
    MOUNTS+=(-v "/:/mnt/host")
    ;;
  Darwin)
    # Docker Desktop on macOS virtualises the filesystem.
    # Configure additional paths in: Docker Desktop → Settings → File Sharing.
    # By default we mount your home directory as a practical full-access proxy.
    MOUNTS+=(-v "${HOME}:/mnt/host")
    info "macOS: host home mounted at /mnt/host. Add more paths in Docker Desktop → File Sharing."
    ;;
esac

# GitHub CLI auth — forwards existing gh login so Copilot works without re-auth
if [ -d "${HOME}/.config/gh" ]; then
  MOUNTS+=(-v "${HOME}/.config/gh:/root/.config/gh")
fi

# SSH keys (read-only — for git operations over SSH)
if [ -d "${HOME}/.ssh" ]; then
  MOUNTS+=(-v "${HOME}/.ssh:/root/.ssh:ro")
fi

# Git global config (read-only)
if [ -f "${HOME}/.gitconfig" ]; then
  MOUNTS+=(-v "${HOME}/.gitconfig:/root/.gitconfig:ro")
fi

# ── Run ───────────────────────────────────────────────────────────────────────
docker run -it --rm \
  "${MOUNTS[@]}" \
  -w "/workspace" \
  -e "TERM=${TERM:-xterm-256color}" \
  -e "COLORTERM=${COLORTERM:-truecolor}" \
  "$IMAGE" \
  "${@:-nvim}"
