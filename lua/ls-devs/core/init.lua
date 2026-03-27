-- ── core/init ────────────────────────────────────────────────────────────
-- Purpose : Root entry point — loads global options, then bootstraps plugins.
--           Keymaps and autocmds are deferred to UIEnter so they don't block
--           the synchronous startup path (saves ~2ms from LazyStart).
-- Trigger : Loaded at startup via the top-level init.lua
-- ─────────────────────────────────────────────────────────────────────────
require("ls-devs.core.options")

-- Defer keymaps and autocmds: neither is needed before UIEnter.
-- Plugin-level keys are registered by lazy.nvim's handler system independently.
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		require("ls-devs.core.keymaps")
		require("ls-devs.core.autocmds")
	end,
})

require("ls-devs.core.lazy")
