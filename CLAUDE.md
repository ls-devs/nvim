# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A modular, performance-first Neovim configuration written in Lua. It is **not** an application — there is no build pipeline, no automated test suite, and no deployable artifact. All validation is manual and done inside a running Neovim instance or via standalone CLI tools.

---

## Startup flow

```
init.lua
  └─ require("ls-devs.core")
       ├─ core/options.lua   (vim options, clipboard detection)
       ├─ core/keymaps.lua   (global keymaps — deferred to UIEnter)
       ├─ core/autocmds.lua  (global autocommands — deferred to UIEnter)
       └─ core/lazy.lua      (lazy.nvim bootstrap → all plugin imports)
```

`defaults = { lazy = true }` is set globally. **Every plugin is lazy by default.** Features must be triggered via `event`, `cmd`, `ft`, or `keys` — never force-load with `lazy = false` unless you have a compelling reason.

---

## Directory structure

```
init.lua                       ← single entry point: require("ls-devs.core")
lua/ls-devs/
  core/                        ← startup (options, keymaps, autocmds, lazy bootstrap)
  plugins/
    completion/                ← blink.cmp, LuaSnip, lspkind
      completion_modules/      ← pure-Lua helpers (NOT imported by lazy.nvim)
    devtools/                  ← codecompanion, debuggers, neotest, overseer, kulala, etc.
      codecompanion.lua        ← SOURCE OF TRUTH for all AI/MCP/Copilot integration
    gittools/                  ← codediff.nvim, gitsigns, git-worktree
    lsp/
      manager.lua              ← Mason package list (LSPs, linters, formatters, DAPs)
    movement/                  ← flash, mini.surround, smart-splits, treesj, etc.
    system/                    ← conform (formatting), nvim-lint, snacks, neo-tree, treesitter, etc.
      snacks/                  ← dashboard.lua, keys.lua, picker.lua (required by snacks.lua)
    ui/                        ← catppuccin, lualine, tabby, noice, ufo, etc.
    utilities/                 ← mini.comment, trouble, scrolleof
  utils/
    custom_functions.lua       ← HelpGrep, CustomHover, OpenURLs, GhSwitch, DapChromeDebug, etc.
lsp/                           ← standalone server config fragments (NOT auto-loaded)
                                 eslint.lua is loaded by manager.lua only
.agents/skills/                ← project-local CodeCompanion agent skills
lazy-lock.json                 ← plugin version lockfile (do not edit manually)
skills-lock.json               ← agent skills lockfile
```

---

## Validation — there is no `make` or `npm test`

In-editor commands after changes:

| Command | Purpose |
|---|---|
| `:Lazy install` | Install missing plugins |
| `:Lazy update` | Update all plugins |
| `:checkhealth` | Check for missing runtime dependencies |
| `:Mason` | View/manage LSP/tool installation |
| `:MasonToolsInstall` | Install all tools defined in `manager.lua` |
| `:ConformInfo` | Inspect active formatter state |

For file-level validation without opening Neovim:

```bash
stylua lua/ls-devs/plugins/system/formatting.lua   # Lua
shellcheck path/to/script.sh                        # Shell
yamllint path/to/file.yaml                          # YAML
jsonlint path/to/file.json                          # JSON
```

---

## Key conventions

### Plugin spec files

Each file in `lua/ls-devs/plugins/<category>/` returns a single lazy.nvim spec table (or list of specs). Do not centralize plugin code outside its spec file.

```lua
return {
  "author/plugin",
  event = "BufReadPost",   -- or cmd, ft, keys
  keys = {
    { "<leader>x", function() ... end, desc = "My feature" },
  },
  opts = { ... },
}
```

- 2-space indentation, Lua table style matching existing files
- Always add `desc` on keymap entries in plugin specs
- Preserve `---@diagnostic disable: undefined-global` headers in files that already have them

### Tooling is split across three files — update all three together

When adding/removing a tool (LSP, linter, formatter, debugger):

| Layer | File |
|---|---|
| Install | `lua/ls-devs/plugins/lsp/manager.lua` → `ensure_installed` list |
| Format | `lua/ls-devs/plugins/system/formatting.lua` → `formatters_by_ft` |
| Lint | `lua/ls-devs/plugins/system/linting.lua` → `linters_by_ft` |

### UI consistency

- Colorscheme: `catppuccin` Mocha (set as `install.colorscheme` in `core/lazy.lua`)
- All floating windows use `border = "rounded"`
- Icons use Nerd Font glyphs — keep consistent when adding new UI surfaces

### Clipboard — preserve environment branches

`core/options.lua` detects the environment at startup:
- **Docker** (`container=docker` or `/.dockerenv` exists): OSC 52 via stdout
- **WSL**: `win32yank` if available, fallback to PowerShell clip
- **Bare Linux / default**: `unnamedplus`

Do not collapse or simplify these branches.

---

## Common change patterns

### Add a new plugin
1. Create `lua/ls-devs/plugins/<category>/myplugin.lua` returning a lazy.nvim spec
2. No registration needed — `core/lazy.lua` imports the entire category directory
3. Use `event`, `cmd`, `ft`, or `keys` to trigger loading
4. If the plugin requires a CLI tool, add it to `manager.lua` `ensure_installed`

### Add a new LSP
1. `manager.lua` → add to `ensure_installed` (LSP section)
2. `mason-lspconfig` with `automatic_enable = true` configures it automatically
3. For custom server settings, add a config block in `manager.lua` or a new file under `lsp/` (and explicitly require it from `manager.lua`)

### Add a new formatter
1. `manager.lua` → add tool to `ensure_installed`
2. `formatting.lua` → add `filetype = { "toolname" }` entry in `formatters_by_ft`

### Add a new linter
1. `manager.lua` → add tool to `ensure_installed`
2. `linting.lua` → add `filetype = { "toolname" }` entry in `linters_by_ft`

### Change a keybinding
Find the plugin spec file for the relevant feature and update the `keys` table entry.

---

## AI / CodeCompanion integration

`lua/ls-devs/plugins/devtools/codecompanion.lua` is the single source of truth for:

- **Chat model**: `copilot / claude-sonnet-4.6`
- **Inline & cmd model**: `copilot / gpt-4.1-mini`
- **MCP Hub** extension: slash-commands + result injection via `ravitemer/mcphub.nvim`
- **Agent skills**: loaded from `~/.agents/skills/` (user-global) and `.agents/skills/` (project-local)
- **Copilot inline suggestions**: auto-trigger on `LspAttach`, `<M-l>` to accept

When modifying CodeCompanion behavior, stay within `codecompanion.lua`. Do not scatter AI config across other files.

---

## What NOT to do

- Do **not** set `lazy = false` without a documented reason
- Do **not** add `format_on_save = true` — it is intentionally disabled
- Do **not** edit `lazy-lock.json` manually
- Do **not** add plugin logic to `core/lazy.lua` — it is a composition point only
- Do **not** assume files in `lsp/` are active — verify in `plugins/lsp/manager.lua` first
- Do **not** place plugin specs in `completion_modules/` — that folder is not imported by lazy.nvim
- Do **not** use `vim.loop.*` — use `vim.uv.*` (deprecated since Neovim 0.10)
- Do **not** use `vim.api.nvim_set_keymap` / `vim.api.nvim_buf_set_keymap` — use `vim.keymap.set()`
- Do **not** change the colorscheme or switch from rounded borders without updating all affected UI plugins

---

## Prerequisites

| Requirement | Used by |
|---|---|
| Neovim ≥ 0.12.0 | everything |
| git | lazy.nvim bootstrap, gitsigns, codediff.nvim |
| Node.js + npm/pnpm | ts_ls, eslint, markdown-preview, copilot.lua |
| Python + pynvim | debugpy, pyright |
| Cargo/Rust | rust_analyzer, blink.cmp build step |
| win32yank | WSL clipboard |
| lazygit | snacks.lazygit float |
| wslview | URL opener in WSL |
