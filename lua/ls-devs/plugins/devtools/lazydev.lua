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
			"luvit-meta/library",
			"lazy.nvim",
			"mason.nvim",
			"mason-lspconfig.nvim",
			"mason-tool-installer.nvim",
			"nvim-lspconfig",
			"lspsaga.nvim",
			"nvim-treesitter",
			"blink.cmp",
			"conform.nvim",
			"nvim-lint",
			"noice.nvim",
			"neo-tree.nvim",
			"telescope.nvim",
			"legendary.nvim",
			"toggleterm.nvim",
			"catppuccin",
			"plenary.nvim",
			"fidget.nvim",
			"alpha-nvim",
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
		enabled = function(root_dir)
			return true
		end,
	},
	dependencies = {
		{ "Bilal2453/luvit-meta", lazy = true },
	},
}
