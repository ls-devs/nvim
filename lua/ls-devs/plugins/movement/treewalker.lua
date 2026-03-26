-- ── treewalker.nvim ───────────────────────────────────────────────────────
-- Purpose : AST-aware code navigation — move between Treesitter nodes
--           (parent / child / sibling) using <M-Arrow> keys.
-- Trigger : BufReadPost
-- Keymaps : <M-Up/Down/Left/Right> in normal and visual modes
-- Note    : <C-Up/Down> are reserved by multiple-cursors.nvim (AddUp/Down).
--           Complements flash (character-level) with semantic-level movement.
--           Brief node highlight (250ms) shows where you land.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"aaronik/treewalker.nvim",
	event = "BufReadPost",
	opts = {
		highlight = true,
		highlight_duration = 250,
	},
	keys = {
		{ "<M-Up>", "<cmd>Treewalker Up<CR>", mode = { "n", "v" }, desc = "Treewalker Up" },
		{ "<M-Down>", "<cmd>Treewalker Down<CR>", mode = { "n", "v" }, desc = "Treewalker Down" },
		{ "<M-Left>", "<cmd>Treewalker Left<CR>", mode = { "n", "v" }, desc = "Treewalker Left" },
		{ "<M-Right>", "<cmd>Treewalker Right<CR>", mode = { "n", "v" }, desc = "Treewalker Right" },
	},
}
