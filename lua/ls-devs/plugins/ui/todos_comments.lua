return {
	"folke/todo-comments.nvim",
	event = "BufReadPost",
	opts = {},
	dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
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
