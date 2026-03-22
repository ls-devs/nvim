-- ── lazydev.nvim ──────────────────────────────────────────────────────────
-- Purpose : Lua type annotations and completions for Neovim config/plugin code
-- Trigger : ft = lua
-- Provides: LuaLS library augmentation, type hints for Neovim APIs
-- Note    : Library list is explicitly curated to match plugins installed in
--           this config; integrates with blink.cmp via the lazydev source
--           (cmp = false because this config uses blink.cmp, not nvim-cmp)
-- ─────────────────────────────────────────────────────────────────────────
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		debug = false,
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } }, -- luv types, only when vim.uv is referenced
			{ path = "snacks.nvim", words = { "Snacks" } }, -- snacks types, only when Snacks is referenced (avoids profiler require pollution)
			"lazy.nvim",
			"legendary.nvim",
			"catppuccin",
			"plenary.nvim",
			"fidget.nvim",
			"nvim-web-devicons",
			"lualine.nvim",
			"nvim-various-textobjs",
			"diffview.nvim",
			"statuscol.nvim",
			"neotab.nvim",
			"nvim-ufo",
		},
		integrations = {
			lspconfig = true,
			cmp = false,
			coq = false,
		},
	},
	dependencies = {},
}
