# Neovim Configuration by ls-devs

## Architecture

This Neovim configuration is modular and organized for performance, extensibility, and IDE-like features. The entrypoint is `init.lua`, which loads the core modules:

- `core/options.lua`: Sets global editor options, keymaps, clipboard integration (Docker/WSL/Win32yank), and UI tweaks.
- `core/lazy.lua`: Bootstraps and configures [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. It imports plugin categories:
  - completion, devtools, gittools, lsp, movement, preview, system, ui, utilities

Plugins are organized by functionality in `lua/ls-devs/plugins/<category>/`. Each plugin file returns a table describing its setup, dependencies, and configuration.

## Functionalities

- **Plugin Management:** Uses lazy.nvim for fast startup and lazy loading.
- **Completion:** Powered by nvim-cmp, LuaSnip, lspkind, and many sources (LSP, buffer, snippets, npm, dotenv, etc.).
- **LSP & Diagnostics:** Integrated with lspsaga.nvim, nvim-lspconfig, mason.nvim, and related tools for language server management and UI enhancements.
- **Git Integration:** Includes diffview.nvim, gitsigns.nvim, fugitive, git-worktree, and more for advanced git workflows.
- **Movement:** Enhanced navigation with flit.nvim, leap.nvim, sentiment.nvim, neotab, and others.
- **UI:** Custom dashboard (alpha-nvim), catppuccin theme, diagflow, blinker, and more.
- **Preview:** Markdown preview (glow.nvim, markdown-preview.nvim), file viewers.
- **Devtools:** AsyncRun, codecompanion, overseer, live-server, typescript-tools, xmake, databases, debugging, etc.
- **System:** Bigfile.nvim, legendary, linting, formatting, telescope, treesitter, toggleterm, wildfire, sleuth, neo-tree, etc.
- **Utilities:** Custom functions, better quickfix, and more.

## Installation

### Prerequisites
- **Neovim >= 0.12.0**
- **Git** (for plugin manager)
- **Node.js** (for npm, markdown preview, LSPs)
- **Python** (for pynvim, Jupyter integration)
- **Cargo/Rust** (for some plugins)
- **Go** (for some LSPs)
- **Java** (for JDTLS)
- **Deno** (for deno LSP)
- **Bun** (optional, for bun completions)
- **SDKMAN** (for JVM tools)
- **Win32yank** (for clipboard integration on WSL)
- **direnv** (for environment management)
- **ghcup** (for Haskell tools)
- **xmake** (optional, for build tools)
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
   - xmake
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
- Completion: nvim-cmp, LuaSnip, lspkind, cmp-buffer, cmp-cmdline, cmp-nvim-lsp, cmp-dotenv, cmp-npm, cmp-rg, cmp-under-comparator, cmp_luasnip
- LSP: mason.nvim, nvim-lspconfig, lspsaga.nvim, etc.
- Git: diffview.nvim, gitsigns.nvim, fugitive, git-worktree
- UI: alpha-nvim, catppuccin, diagflow, blinker
- Preview: glow.nvim, markdown-preview.nvim
- Movement: flit.nvim, leap.nvim, sentiment.nvim, neotab
- Devtools: AsyncRun, codecompanion, overseer, live-server, typescript-tools, xmake
- System: bigfile.nvim, legendary, linting, formatting, telescope, treesitter, toggleterm, wildfire, sleuth, neo-tree

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
