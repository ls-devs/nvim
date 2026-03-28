# Neovim Configuration by ls-devs

## Architecture

This Neovim configuration is modular and organized for performance, extensibility, and IDE-like features. The entrypoint is `init.lua`, which loads the core modules:

- `core/options.lua`: Sets global editor options and clipboard integration (Docker/WSL/Win32yank).
- `core/keymaps.lua`: Global keymaps.
- `core/autocmds.lua`: Global autocommands.
- `core/lazy.lua`: Bootstraps and configures [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. It imports plugin categories:
  - completion, devtools, gittools, lsp, movement, system, ui, utilities

Plugins are organized by functionality in `lua/ls-devs/plugins/<category>/`. Each plugin file returns a table describing its setup, dependencies, and configuration.

## Functionalities

- **Plugin Management:** Uses lazy.nvim for fast startup and lazy loading.
- **Completion:** Powered by blink.cmp (v2/main, Rust fuzzy matching), LuaSnip, lspkind, and sources (LSP, buffer, snippets, Copilot, dotenv, sass-variables, git).
- **LSP & Diagnostics:** Integrated with lspsaga.nvim, nvim-lspconfig, mason.nvim, and related tools for language server management and UI enhancements.
- **Git Integration:** Includes codediff.nvim (diff viewer + conflict resolution), gitsigns.nvim, git-worktree, and more for advanced git workflows.
- **Movement:** Enhanced navigation with flash.nvim, mini.surround, multiple-cursors, neotab, nvim-spider, nvim-autopairs, smart-splits, treesj, treewalker, vim-matchup, and others.
- **UI:** Snacks dashboard, catppuccin theme, tiny-inline-diagnostic.nvim, mini.icons, noice, lualine, tabby, todo-comments, and more.
- **Devtools:** AsyncRun, codecompanion (AI/MCP/Copilot), overseer, live-server, typescript-tools, kulala.nvim, databases, debugging (DAP + multi-language launch configs), lazydev, neotest (jest/vitest/pytest/cargo/phpunit), rustaceanvim (enhanced Rust LSP + DAP), octo.nvim (GitHub PR/issue management), iron.nvim (interactive REPL), nvim-coverage (test coverage gutter), ccc.nvim (inline color picker/highlighter).
- **System:** Snacks (bigfile, terminal, input, scroll, indent, picker, notifier, dashboard), linting (nvim-lint), formatting (conform.nvim), treesitter, neo-tree, grug-far, markview, sleuth, wildfire, treesitter-context (sticky scope header), etc.
- **Utilities:** Mini.comment, trouble, and more.

## Getting Started

There are two ways to use this configuration. Both are fully automated — just clone and run one script.

### Option A — Native install (your machine)

> Supports: Ubuntu/Debian · Fedora/RHEL · Arch · openSUSE · Alpine · macOS (Homebrew) · WSL

```bash
git clone <repo-url> ~/.config/nvim
cd ~/.config/nvim/setup

# Linux / macOS / WSL
chmod +x install.sh && ./install.sh

# Windows (PowerShell — run as Administrator)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
.\install.ps1
```

The script will:
1. Install all system packages (build tools, runtimes, CLI tools)
2. Install Neovim, Rust, Node.js, Go, Java, lazygit, pnpm, pynvim, gh CLI, FiraCode Nerd Font
3. Run `:Lazy install` — installs all plugins (includes blink.cmp Rust build)
4. Run `:MasonToolsInstallSync` — installs all LSPs, formatters, linters, and debuggers
5. Run `:TSUpdate` — installs treesitter parsers
6. Prompt for `gh auth login` (GitHub browser OAuth — needed for Copilot + octo.nvim)
7. Install the `gh copilot` CLI extension

### Option B — Docker (any OS, zero host dependencies)

> Requires: Docker Desktop or Docker Engine

```bash
git clone <repo-url> ~/.config/nvim

# Linux / macOS / WSL
./setup/docker-run.sh

# Windows (PowerShell)
.\setup\docker-run.ps1
```

- Builds the full environment image on first run (~15–25 min)
- Subsequent runs start instantly
- Your files are accessible at `/mnt/host` (Linux/macOS) or `/mnt/c` (Windows)
- GitHub CLI auth (`~/.config/gh`) is forwarded automatically from your host
- SSH keys and `.gitconfig` are forwarded read-only

> **First-time Docker users:** run `gh auth login` on your host machine once before starting the container, so the auth is forwarded automatically.

## setup/ folder

| File | Purpose |
|---|---|
| `install.sh` | Fully automated native installer for Linux, macOS, WSL |
| `install.ps1` | Fully automated native installer for Windows |
| `Dockerfile` | Docker image with all tools + pre-baked plugins |
| `.dockerignore` | Build exclusions |
| `docker-run.sh` | Build + launch container (Linux/macOS/WSL) |
| `docker-run.ps1` | Build + launch container (Windows PowerShell) |

## Updating

```vim
:Lazy update        " update plugins
:Mason update       " update LSP/tool versions
```

## Troubleshooting

- Run `:checkhealth` inside Neovim — covers all runtimes, clipboard, and providers
- **Font icons not showing:** ensure your terminal uses **FiraCode Nerd Font**
- **Copilot not working:** run `gh auth login` then `gh extension install github/gh-copilot`
- **Mason tools failing:** ensure Node.js, Python, Go, and Rust are on your PATH; re-run `:MasonToolsInstall`
- **blink.cmp errors:** Rust/Cargo must be installed before `:Lazy install`

## Credits

Plugin authors, Neovim community, ls-devs

---

For a full plugin list and pinned versions, see [`lazy-lock.json`](lazy-lock.json).

