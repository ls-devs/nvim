# Copilot Instructions

## Build, test, lint, and validation commands

This repository is a Neovim configuration, not an application with a repo-local build or automated test suite.

Use the validation flows that are actually wired by the config:

```vim
:Lazy install
:Lazy update
:checkhealth
:Mason
:MasonToolsInstall
:ConformInfo
```

The main manual formatting entrypoint is `<leader>fm`, backed by `stevearc/conform.nvim` in `lua/ls-devs/plugins/system/formatting.lua`. Format-on-save is explicitly disabled there (`format_on_save = false`).

Linting is driven by `mfussenegger/nvim-lint` in `lua/ls-devs/plugins/system/linting.lua` and runs on `BufWritePost`, `BufReadPost`, and `InsertLeave`.

For targeted validation on a single file, run the formatter or linter that matches the filetype mapping in `formatting.lua` and `linting.lua`, for example:

```bash
stylua path/to/file.lua
black path/to/file.py
ruff check path/to/file.py
prettierd path/to/file.ts
shellcheck path/to/file.sh
jsonlint path/to/file.json
yamllint path/to/file.yaml
```

Tool installation is managed through Mason and `mason-tool-installer.nvim` in `lua/ls-devs/plugins/lsp/manager.lua`, which defines the repo’s expected LSPs, linters, formatters, and debuggers.

## High-level architecture

Startup is minimal: `init.lua` only requires `ls-devs.core`, and `lua/ls-devs/core/init.lua` immediately loads `core/options.lua` and `core/lazy.lua`.

`lua/ls-devs/core/lazy.lua` is the main composition point. It bootstraps `lazy.nvim`, then imports plugin specs from the repo’s category namespaces:

- `ls-devs.plugins.completion`
- `ls-devs.plugins.completion.completion_modules`
- `ls-devs.plugins.devtools`
- `ls-devs.plugins.gittools`
- `ls-devs.plugins.lsp`
- `ls-devs.plugins.movement`
- `ls-devs.plugins.system`
- `ls-devs.plugins.system.dependencies`
- `ls-devs.plugins.system.telescope_extensions`
- `ls-devs.plugins.system.treesitter_modules`
- `ls-devs.plugins.ui`
- `ls-devs.plugins.utilities`

The big-picture split is:

- `core/`: startup behavior, global options, environment-aware defaults
- `plugins/`: lazy.nvim specs grouped by feature area
- `lsp/`: standalone server config fragments that exist alongside the plugin-based LSP setup
- `utils/`: custom Lua helpers reused by plugin configs

Important cross-file behavior:

- All plugins default to `lazy = true` in `core/lazy.lua`, so most behavior should be added behind `event`, `cmd`, `ft`, or `keys` triggers instead of forcing eager startup.
- Clipboard setup in `core/options.lua` changes based on environment: OSC52 in Docker, `win32yank` or PowerShell clipboard in WSL, and `unnamedplus` globally afterward. Changes in that file should preserve those branches.
- Tooling is split across three places: Mason package installation in `plugins/lsp/manager.lua`, formatting mappings in `plugins/system/formatting.lua`, and lint mappings/autocmds in `plugins/system/linting.lua`.
- AI tooling is centered in `plugins/devtools/codecompanion.lua`, which wires CodeCompanion, Copilot, MCP Hub, and agent skills together. That file is the source of truth for Copilot chat/inline/cmd models, MCP slash-command integration, and custom prompt library entries.

## Key conventions

Plugin config files are lazy.nvim spec files. Prefer editing or adding a single spec file in the appropriate `lua/ls-devs/plugins/<category>/` directory rather than centralizing plugin code elsewhere.

Keep to the existing lazy-loading style:

- use `event`, `cmd`, `ft`, or `keys` to load features
- add `desc` on keymaps in plugin specs
- match the existing 2-space indentation and Lua table style
- preserve `---@diagnostic disable: undefined-global` headers when a file already uses them

When changing tooling behavior, update all relevant layers together:

- Mason package list in `lua/ls-devs/plugins/lsp/manager.lua`
- formatter mappings in `lua/ls-devs/plugins/system/formatting.lua`
- linter mappings in `lua/ls-devs/plugins/system/linting.lua`

Do not assume the standalone files under `lsp/` are automatically active. They exist, but the active wiring visible in this repo is the Mason/lazy.nvim setup under `lua/ls-devs/plugins/lsp/`. If you need to change language-server behavior, verify where that server is actually configured before editing.

Theme and UI choices are intentional and shared across files: `catppuccin` is the install colorscheme in `core/lazy.lua`, and multiple UI plugins use rounded borders and Nerd Font icons. Try to preserve those defaults when adding new UI surfaces.

For CodeCompanion and MCP-related work, keep changes in `lua/ls-devs/plugins/devtools/codecompanion.lua` aligned with the existing extension layout:

- `mcphub` extension for slash commands and result injection
- `agentskills` paths pointing at `~/.agents/skills/` and `.agents/skills/`
- Copilot-backed models for chat, inline edits, and command mode

The README is useful for prerequisites and user-facing install/update flows, but some architecture details in code are more current than the prose. Prefer the code as the source of truth when they differ.
