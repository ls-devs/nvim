# Adapting DAP/Debugging Setup to New Projects

This Neovim configuration provides a modular, extensible DAP (Debug Adapter Protocol) setup supporting JavaScript/TypeScript (Node, Chrome), Python, Bash, and Lua. The system is designed for easy adaptation to new projects and custom workflows.

## Where to Plug in Custom Logic

- **DAP Adapters & Configurations:**
  - Edit or extend `lua/ls-devs/plugins/devtools/debuggers.lua`.
  - Add new adapters in the `mfussenegger/nvim-dap` config block.
  - Add/modify language-specific configurations in the same block (see JS/TS, Python, Bash, Lua examples).

- **Custom Launch/Attach Logic:**
  - Place reusable helpers in `lua/ls-devs/utils/custom_functions.lua`.
  - Example: `DapNodeDebug` and `DapChromeDebug` provide project-aware, full-stack debugging for JS/TS monorepos and WSL/Arc workflows.
  - Add new helpers for project-specific needs (e.g., custom port detection, framework launchers).

- **Keybindings:**
  - Add or update DAP-related keymaps in the `keys` table of `debuggers.lua`.
  - Use `desc` for discoverability (shows in keymap pickers).

## Using the Modular Helpers

- **Node/Frontend Debugging:**
  - `<leader>dN` runs `DapNodeDebug`, auto-detecting backend/frontend scripts from `package.json`.
  - Supports full-stack (backend + frontend) launch, port polling, and browser attach.

- **Chrome/Arc Debugging (WSL):**
  - `<leader>dC` runs `DapChromeDebug`, handling Arc browser quirks and WSL networking.
  - Prompts for a URL, launches Arc with debugging enabled, and attaches via DAP.

- **Adding New Languages/Frameworks:**
  - Add a new adapter and configuration in `debuggers.lua`.
  - For custom launch/attach flows, add a helper in `custom_functions.lua` and wire it to a keymap.

## Best Practices

- Keep all project-specific logic in helpers, not in plugin spec tables.
- Use the provided helpers as templates for new workflows.
- Document new keymaps and helpers for team discoverability.

See `debuggers.lua` and `custom_functions.lua` for working examples and patterns.
