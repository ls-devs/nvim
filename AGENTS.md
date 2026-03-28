# AGENTS.md — AI Agent Guide for ls-devs/nvim

This file is the authoritative reference for AI agents (Copilot, Claude, Cursor, etc.) working in this repository. Read it fully before making any changes.

---

## What this repository is

A modular, performance-first Neovim configuration written in Lua. It is **not** an application — there is no build pipeline, no automated test suite, and no deployable artifact. All validation is manual and done inside a running Neovim instance or via standalone CLI tools.

---

## Directory structure

```
init.lua                       ← single entry point: require("ls-devs.core")
lua/ls-devs/
  core/
    init.lua                   ← loads options.lua, keymaps.lua, autocmds.lua, then lazy.lua
    options.lua                ← global vim options, env-aware clipboard
    keymaps.lua                ← global keymaps
    autocmds.lua               ← global autocommands
    lazy.lua                   ← lazy.nvim bootstrap + all plugin spec imports
  plugins/
    completion/                ← blink.cmp, LuaSnip, lspkind
      completion_modules/      ← non-spec Lua helpers (dotenv_source.lua); NOT imported by lazy.nvim
      blink_cmp.lua            ← main completion config (v2/main branch, cargo build)
    devtools/                  ← codecompanion (+ copilot dep + img-clip dep), debuggers, databases,
    │                            asyncrun, overseer, kulala.nvim, typescript-tools,
    │                            live-server, lazydev, emmet,
    │                            neotest (+ adapters), rustaceanvim, octo.nvim,
    │                            iron.nvim (REPL), nvim-coverage, ccc.nvim (color picker)
    │   codecompanion.lua      ← SOURCE OF TRUTH for AI/MCP/Copilot integration
    gittools/                  ← codediff.nvim (diff viewer + conflict resolution), gitsigns, git-worktree
    lsp/
      manager.lua              ← Mason package list (LSPs, linters, formatters, DAPs)
      lspsaga.lua
    movement/                  ← flash, mini.surround, multiple-cursors, neotab,
    │                            nvim-autopairs, nvim-spider, smart-splits, treesj, treewalker, vim-matchup
    system/
      formatting.lua           ← conform.nvim formatter mappings (format_on_save=false)
      linting.lua              ← nvim-lint linter mappings + autocmd wiring
      snacks.lua               ← replaces bigfile, alpha, telescope, toggleterm, dressing-input
      snacks/                  ← dashboard.lua, keys.lua, picker.lua (loaded via require in snacks.lua)
      neo_tree.lua
      treesitter.lua
      sleuth.lua, wildfire.lua, markview.lua, grug_far.lua, gx.lua, early_retirement.lua,
      treesitter_context.lua, which_key.lua
      dependencies/            ← plenary, luarocks
      treesitter_modules/      ← nvim-ts-autotag
    ui/                        ← catppuccin, tiny-inline-diagnostic, fidget, focus, lualine, mini_icons,
    │                            noice, reactive, stickybuf, tabby, todo-comments, ufo, nvim-bqf, quicker
    utilities/                 ← mini.comment, scrolleof, trouble
  utils/
    custom_functions.lua       ← HelpGrep, CustomHover, OpenURLs, GhSwitch,
                                  OrigamiHLFolds, KeymapsList, AutocmdsList, CommandsList,
                                  HighlightsList, DapChromeDebug, DapNodeDebug
lsp/                           ← standalone server config fragments (NOT auto-loaded by default)
                                 eslint.lua: loaded by manager.lua; suppresses publishDiagnostics
                                   so the eslint LSP only provides code actions (not diagnostics)
.agents/skills/                ← local CodeCompanion agent skills
.github/copilot-instructions.md ← Copilot-specific subset of this file
skills-lock.json               ← installed agent skills lockfile
lazy-lock.json                 ← plugin version lockfile (do not edit manually)
```

---

## Startup flow

```
init.lua
  └─ require("ls-devs.core")
       ├─ core/options.lua   (vim options, clipboard detection)
       ├─ core/keymaps.lua   (global keymaps)
       ├─ core/autocmds.lua  (global autocommands)
       └─ core/lazy.lua      (lazy.nvim bootstrap → all plugin imports)
```

`defaults = { lazy = true }` is set globally. **Every plugin is lazy by default.** Features must be triggered via `event`, `cmd`, `ft`, or `keys` — never force-load with `lazy = false` unless you have a compelling reason.

---

## Validation — there is no `make` or `npm test`

Use these in-editor commands after changes:

| Command | Purpose |
|---|---|
| `:Lazy install` | Install missing plugins |
| `:Lazy update` | Update all plugins |
| `:checkhealth` | Check for missing runtime dependencies |
| `:Mason` | View/manage LSP/tool installation |
| `:MasonToolsInstall` | Install all tools defined in `manager.lua` |
| `:ConformInfo` | Inspect active formatter state |

For **file-level validation** without opening Neovim, run the formatter or linter that matches the filetype:

```bash
# Lua (any file in this repo)
stylua lua/ls-devs/plugins/system/formatting.lua

# Shell
shellcheck path/to/script.sh

# JSON
jsonlint path/to/file.json

# YAML
yamllint path/to/file.yaml
```

Formatter-to-filetype and linter-to-filetype mappings are the canonical truth in `formatting.lua` and `linting.lua`.

---

## Key conventions

### Plugin spec files
Each file in `lua/ls-devs/plugins/<category>/` returns a single lazy.nvim spec table (or a list of specs). Do not centralize plugin code outside its spec file.

```lua
-- Good: in lua/ls-devs/plugins/system/myfeature.lua
return {
  "author/plugin",
  event = "BufReadPost",
  keys = {
    { "<leader>x", function() ... end, desc = "My feature" },
  },
  opts = { ... },
}
```

### Indentation and style
- 2-space indentation, Lua table style matching existing files
- Preserve `---@diagnostic disable: undefined-global` headers in files that already have them
- Always add `desc` on keymap entries in plugin specs

### Tooling is split across three files — update all three together

When adding/removing a tool (LSP, linter, formatter, debugger):

| Layer | File |
|---|---|
| Install | `lua/ls-devs/plugins/lsp/manager.lua` — `ensure_installed` list |
| Format | `lua/ls-devs/plugins/system/formatting.lua` — `formatters_by_ft` |
| Lint | `lua/ls-devs/plugins/system/linting.lua` — `linters_by_ft` |

### `completion_modules/` — not imported by lazy.nvim
Files under `lua/ls-devs/plugins/completion/completion_modules/` are **not** plugin specs and are **not** imported by `core/lazy.lua`. The folder exists for pure-Lua helpers used by `blink_cmp.lua` (e.g. `dotenv_source.lua`). Do not place lazy.nvim specs there.

### `lsp/` directory — not auto-loaded
Files under the top-level `lsp/` are **not** imported by `core/lazy.lua`. The active LSP configuration is fully managed through Mason and `nvim-lspconfig` via `plugins/lsp/manager.lua`. Before editing any LSP behavior, verify which file actually controls it.

### UI consistency
- Colorscheme: `catppuccin` (set in `core/lazy.lua` `install.colorscheme`)
- All floating windows use `border = "rounded"`
- Icons use Nerd Font glyphs — keep this consistent when adding new UI surfaces

### Clipboard — preserve environment branches
`core/options.lua` has three clipboard branches (detected at startup):
- **Docker** (`container=docker` or `/.dockerenv` exists): OSC 52 via stdout
- **WSL**: `win32yank` if available, fallback to PowerShell clip
- **Bare Linux / default**: `unnamedplus`

Do not collapse or simplify these branches.

---

## AI / CodeCompanion integration

`lua/ls-devs/plugins/devtools/codecompanion.lua` is the single source of truth for:

- **Chat model**: `copilot / claude-sonnet-4.6`
- **Inline & cmd model**: `copilot / gpt-4.1-mini`
- **CLI agent**: `copilot` CLI via `CodeCompanionCLI`
- **MCP Hub** extension: slash-commands + result injection via `ravitemer/mcphub.nvim`
- **Agent skills** (`cairijun/codecompanion-agentskills.nvim`): loaded from:
  - `~/.agents/skills/` (user-global, recursive)
  - `.agents/skills/` (project-local, recursive)
- **Copilot inline suggestions** (`zbirenbaum/copilot.lua`): auto-trigger on `LspAttach`, `<M-l>` to accept
- **Custom prompt library**: Code Review, Optimize, Document, Explain, Refactor, Secure, etc.

When modifying CodeCompanion behavior, stay within `codecompanion.lua`. Do not scatter AI config across other files.

---

## Agent skills

Project-local skills live in `.agents/skills/`. The skills lockfile is `skills-lock.json`.

Currently installed project skill: `lazy-nvim-optimization` (from `kriscard/kriscard-claude-plugins`) — profiles Neovim startup and optimizes lazy-loading specs.

To add a skill, update `skills-lock.json` and place the skill file under `.agents/skills/` (or `~/.agents/skills/` for user-global installation).

---

## Common change patterns

### Add a new plugin
1. Create `lua/ls-devs/plugins/<category>/myplugin.lua` returning a lazy.nvim spec
2. No registration needed — `core/lazy.lua` imports the entire category directory
3. Use `event`, `cmd`, `ft`, or `keys` to trigger loading
4. If the plugin requires a CLI tool, add it to `manager.lua` `ensure_installed`

### Add a new LSP
1. `manager.lua` → add to `ensure_installed` (LSP section)
2. `mason-lspconfig.nvim` with `automatic_enable = true` will configure it automatically
3. If custom server settings are needed, add a config block in `manager.lua` or a new file under `lsp/` (and explicitly require it)

### Add a new formatter
1. `manager.lua` → add tool to `ensure_installed` (Formatters section)
2. `formatting.lua` → add `filetype = { "toolname" }` entry in `formatters_by_ft`

### Add a new linter
1. `manager.lua` → add tool to `ensure_installed` (Linters section)
2. `linting.lua` → add `filetype = { "toolname" }` entry in `linters_by_ft`

### Change a keybinding
Find the plugin spec file for the relevant feature and update the `keys` table entry.

---

## What NOT to do

- Do **not** set `lazy = false` without a documented reason
- Do **not** add `format_on_save = true` — it is intentionally disabled
- Do **not** edit `lazy-lock.json` manually
- Do **not** add plugin logic to `core/lazy.lua` — it is a composition point only
- Do **not** assume files in `lsp/` are active — verify in `plugins/lsp/manager.lua` first
- Do **not** change the `catppuccin` colorscheme or switch to square borders without updating all affected UI plugins
- Do **not** place plugin specs in `completion_modules/` — that folder is not imported by lazy.nvim
- Do **not** use `vim.loop.*` — use `vim.uv.*` (vim.loop is deprecated since Neovim 0.10)
- Do **not** use `vim.api.nvim_set_keymap` / `vim.api.nvim_buf_set_keymap` — use `vim.keymap.set()`

---

## Prerequisites summary (for `:checkhealth` failures)

| Requirement | Used by |
|---|---|
| Neovim ≥ 0.12.0 | everything |
| git | lazy.nvim bootstrap, gitsigns, codediff.nvim |
| Node.js + npm/pnpm | ts_ls, eslint, markdown-preview, copilot.lua |
| Python + pynvim | debugpy, pyright |
| Cargo/Rust | rust_analyzer, some plugins |
| Go | gopls (if added), some tools |
| Java (JDK) | jdtls |
| Deno | deno LSP |
| win32yank | WSL clipboard |
| lazygit | snacks.lazygit float |
| wslview | URL opener in WSL (`gx.lua`, lazy.nvim UI browser) |
