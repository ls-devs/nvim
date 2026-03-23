# Neovim Configuration by ls-devs

## Architecture

This Neovim configuration is modular and organized for performance, extensibility, and IDE-like features. The entrypoint is `init.lua`, which loads the core modules:

- `core/options.lua`: Sets global editor options, keymaps, clipboard integration (Docker/WSL/Win32yank), and UI tweaks.
- `core/lazy.lua`: Bootstraps and configures [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. It imports plugin categories:
  - completion, devtools, gittools, lsp, movement, system, ui, utilities

Plugins are organized by functionality in `lua/ls-devs/plugins/<category>/`. Each plugin file returns a table describing its setup, dependencies, and configuration.

## Functionalities

- **Plugin Management:** Uses lazy.nvim for fast startup and lazy loading.
- **Completion:** Powered by blink.cmp (v2/main, Rust fuzzy matching), LuaSnip, lspkind, and sources (LSP, buffer, snippets, Copilot, dotenv, sass-variables, git).
- **LSP & Diagnostics:** Integrated with lspsaga.nvim, nvim-lspconfig, mason.nvim, and related tools for language server management and UI enhancements.
- **Git Integration:** Includes diffview.nvim, gitsigns.nvim, fugitive, git-worktree, and more for advanced git workflows.
- **Movement:** Enhanced navigation with flash.nvim, mini.surround, multiple-cursors, neotab, nvim-spider, nvim-autopairs, smart-splits, treesj, vim-matchup, and others.
- **UI:** Snacks dashboard, catppuccin theme, diagflow, mini.icons, noice, lualine, tabby, todo-comments, and more.
- **Devtools:** AsyncRun, codecompanion (AI/MCP/Copilot), overseer, live-server, typescript-tools, kulala.nvim, databases, debugging (DAP + multi-language launch configs), lazydev, neotest (jest/vitest/pytest/cargo/phpunit), rustaceanvim (enhanced Rust LSP + DAP), octo.nvim (GitHub PR/issue management), iron.nvim (interactive REPL), nvim-coverage (test coverage gutter), ccc.nvim (inline color picker/highlighter).
- **System:** Snacks (bigfile, terminal, input, scroll, indent, picker, notifier, dashboard), linting (nvim-lint), formatting (conform.nvim), treesitter, neo-tree, grug-far, markview, sleuth, wildfire, treesitter-context (sticky scope header), etc.
- **Utilities:** Mini.comment, trouble, and more.

## Installation

### Prerequisites
- **Neovim >= 0.12.0**
- **Git** (for plugin manager)
- **Node.js** (for npm, markdown preview, LSPs)
- **Python** (for pynvim, Jupyter integration)
- **Cargo/Rust** (for blink.cmp fuzzy matching, rust_analyzer)
- **Go** (for some LSPs)
- **Java** (for JDTLS)
- **Deno** (for deno LSP)
- **Bun** (optional, for bun completions)
- **SDKMAN** (for JVM tools)
- **Win32yank** (for clipboard integration on WSL)
- **direnv** (for environment management)
- **ghcup** (for Haskell tools)
- **Spaceship ZSH** (for prompt, if using zsh)
- **Oh-My-Zsh** (for shell plugins)

### Steps
1. **Clone this repo:**
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```
2. **Install Neovim >= 0.12.0**
3. **Install [lazy.nvim](https://github.com/folke/lazy.nvim):**
   The config bootstraps lazy.nvim automatically, but ensure git is installed.
4. **Install required system tools:**
   - Node.js, npm, pnpm, yarn
   - Python, pip, pynvim
   - Cargo, Rust
   - Go
   - Java (for JDTLS)
   - Deno
   - Bun
   - SDKMAN
   - Win32yank (WSL clipboard)
   - direnv
   - ghcup
   - Spaceship ZSH, Oh-My-Zsh

5. **Install plugin dependencies:**
   - Open Neovim and run:
     ```
     :Lazy install
     :Mason install <lsp/tools>
     ```
   - For LuaSnip: `make install_jsregexp` if prompted.

6. **Optional:**
   - Configure your shell (`~/.zshrc`) for PATH and plugin completions.
   - Set up environment managers (pyenv, nvm, envman, etc.)

### Third-party Tools & Plugins
- See `lazy-lock.json` for all plugin sources and versions.
- Shell plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`, Spaceship ZSH, Oh-My-Zsh
- Environment managers: pyenv, nvm, envman, direnv, ghcup, SDKMAN
- Clipboard: win32yank (WSL), OSC52 (Docker)
- Completion: blink.cmp (v2/main), LuaSnip, lspkind, blink.compat, cmp-sass-variables, blink-cmp-git, emmet
- LSP: mason.nvim, nvim-lspconfig, lspsaga.nvim, mason-lspconfig, mason-tool-installer, schemastore
- Git: diffview.nvim, gitsigns.nvim, fugitive, git-conflict, git-worktree
- UI: snacks.nvim (dashboard, input, notifier), catppuccin, diagflow, mini.icons, noice, lualine, tabby, fidget, focus, reactive, stickybuf, todo-comments, nvim-ufo, better-quickfix
- Movement: flash.nvim, mini.surround, multiple-cursors, neotab, nvim-autopairs, nvim-spider, smart-splits, treesj, vim-matchup
- Devtools: AsyncRun, codecompanion (AI/MCP/Copilot + img-clip dep), overseer, live-server, typescript-tools, kulala.nvim, databases, debuggers (DAP + multi-language configs), lazydev, neotest (jest/vitest/pytest/cargo/phpunit), rustaceanvim, octo.nvim, iron.nvim (REPL), nvim-coverage, ccc.nvim (color picker)
- System: snacks.nvim (bigfile, terminal, scroll, indent, picker, dashboard), conform.nvim (formatting), nvim-lint (linting), treesitter, neo-tree, grug-far, markview, wildfire, sleuth, gx, early-retirement, nvim-treesitter-context

## Updating
- Run `:Lazy update` to update plugins.
- Run `:Mason update` for LSP/tool updates.

## Troubleshooting
- Check `:checkhealth` for missing dependencies.
- Review `~/.zshrc` for PATH and environment setup.

## Credits
- Plugin authors, Neovim community, ls-devs

---
For detailed plugin list and versions, see `lazy-lock.json`.
