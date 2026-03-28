-- ── scrollEOF.nvim ────────────────────────────────────────────────────────
-- Purpose : Allow scrolling past the end of the file while respecting scrolloff
-- Trigger : event — BufReadPost, BufNewFile
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"Aasim-A/scrollEOF.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- Disable in non-editing panels where scrolloff behaviour is unwanted
		disabled_filetypes = {
			"terminal",
			"lazy",
			"neo-tree",
			"snacks_dashboard",
			"mason",
			"help",
			"qf",
			"neotest-summary",
			"trouble",
			"Trouble",
		},
	},
}
