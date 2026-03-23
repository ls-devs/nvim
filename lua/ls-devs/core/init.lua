-- ── core/init ────────────────────────────────────────────────────────────
-- Purpose : Root entry point — loads global options, keymaps, autocmds,
--           then bootstraps plugins.
-- Trigger : Loaded at startup via the top-level init.lua
-- ─────────────────────────────────────────────────────────────────────────
require("ls-devs.core.options")
require("ls-devs.core.keymaps")
require("ls-devs.core.autocmds")
require("ls-devs.core.lazy")
