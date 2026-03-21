-- ── flit.nvim ─────────────────────────────────────────────────────────────
-- Purpose : Repeatable f/t/F/T motions enhanced with leap.nvim label hints
-- Trigger : keys — f, F, t, T
-- Note    : Depends on leap.nvim (codeberg mirror), vim-repeat, and
--           telepath.nvim; telepath.use_default_mappings() wires cross-window
--           leap motions on load
-- ─────────────────────────────────────────────────────────────────────────
return {
	"ggandor/flit.nvim",
	opts = {
		keys = { f = "f", F = "F", t = "t", T = "T" },
		labeled_modes = "nvo", -- show jump labels in normal, visual, and operator-pending modes
		multiline = true, -- allow jumping to matches on other lines
	},
	keys = {
		"f",
		"F",
		"t",
		"T",
	},
	dependencies = {
		{ "https://codeberg.org/andyg/leap.nvim", lazy = true },
		{ "tpope/vim-repeat", lazy = true },
		{
			"rasulomaroff/telepath.nvim",
			lazy = true,
			config = function()
				-- overwrite = true replaces any existing leap mappings so telepath owns cross-window motions
				require("telepath").use_default_mappings({ overwrite = true })
			end,
		},
	},
}
