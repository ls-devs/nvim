-- ── wildfire.nvim ────────────────────────────────────────────────────────
-- Purpose : Incremental selection expansion by syntax nodes / surrounds
-- Trigger : keys <C-Space> (expand), <BS> (shrink)
-- Note    : <C-Space> does not conflict with blink.cmp — blink activates
--           only in insert mode while wildfire operates in normal mode.
--           nvim-treesitter's built-in incremental_selection is disabled
--           in treesitter.lua to avoid keybinding collision.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"sustech-data/wildfire.nvim",
	keys = {
		"<C-Space>",
	},
	opts = {
		surrounds = {
			{ "(", ")" },
			{ "{", "}" },
			{ "<", ">" },
			{ "[", "]" },
		},
		keymaps = {
			init_selection = "<C-Space>",
			node_incremental = "<C-Space>",
			node_decremental = "<BS>",
		},
		filetype_exclude = { "qf" }, --keymaps will be unset in excluding filetypes
	},
}
