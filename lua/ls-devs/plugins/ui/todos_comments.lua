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
