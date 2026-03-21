-- ── core/init ────────────────────────────────────────────────────────────
-- Purpose : Root entry point — loads global options then bootstraps plugins.
-- Trigger : Loaded at startup via the top-level init.lua
-- ─────────────────────────────────────────────────────────────────────────
require("ls-devs.core.options")
require("ls-devs.core.lazy")
