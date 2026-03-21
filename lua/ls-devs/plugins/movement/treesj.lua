-- ── treesj ────────────────────────────────────────────────────────────────
-- Purpose : Treesitter-aware split/join of function args, tables, and blocks
-- Trigger : keys — gJ (join), gS (split), gM (toggle)
-- Note    : gJ intentionally overrides Vim's native gJ (join without spaces);
--           dot_repeat=true enables repeating the last join/split with .
-- ─────────────────────────────────────────────────────────────────────────
return {
	"Wansmer/treesj",
	keys = {
		{
			"gJ",
			function()
				require("treesj").join()
			end,
			desc = "TreeSJ Join",
			noremap = true,
			silent = true,
		},
		{
			"gS",
			function()
				require("treesj").split()
			end,
			desc = "TreeSJ Split",
			noremap = true,
			silent = true,
		},
		{
			"gM",
			function()
				require("treesj").toggle()
			end,
			desc = "TreeSJ Toggle",
			noremap = true,
			silent = true,
		},
	},
	dependencies = { { "nvim-treesitter/nvim-treesitter", lazy = true } },
	opts = {
		use_default_keymaps = false, -- custom gJ/gS/gM mappings are defined above
		check_syntax_error = true, -- refuse to split/join if the result would be syntactically invalid
		max_join_length = 120, -- don't join when the resulting line would exceed this column width
		cursor_behavior = "hold", -- keep cursor position unchanged after join/split
		notify = true,
		dot_repeat = true,
	},
}
