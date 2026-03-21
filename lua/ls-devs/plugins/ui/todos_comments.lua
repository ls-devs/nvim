-- ── todo-comments.nvim ───────────────────────────────────────────────────────
-- Purpose : Highlights and searches TODO/FIXME/HACK/NOTE/WARN/PERF/TEST
--           comment keywords across the project.
-- Trigger : BufReadPost
-- Note    : <leader>T=TodoTrouble (list), <leader>TT=TodoTelescope (search).
--           opts={} uses all built-in keyword defaults.
-- ─────────────────────────────────────────────────────────────────────────────
return {
	"folke/todo-comments.nvim",
	event = "BufReadPost",
	opts = {},
	dependencies = { "plenary.nvim", lazy = true },
	keys = {
		{
			"<leader>T",
			"<cmd>TodoTrouble<CR>",
			desc = "TodoTrouble",
			silent = true,
			noremap = true,
		},
		{
			"<leader>TT",
			"<cmd>TodoTelescope<CR>",
			desc = "TodoTelescope",
			silent = true,
			noremap = true,
		},
	},
}
