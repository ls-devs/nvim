return {
	"rest-nvim/rest.nvim",
	ft = "http",
	dependencies = { "luarocks.nvim" },
	keys = {
		{
			"<leader>rh",
			"<cmd>Rest run<CR>",
			desc = "RestNvim",
			noremap = true,
			silent = true,
		},
		{
			"<leader>rl",
			"<cmd>Rest run last<CR>",
			desc = "RestNvimLast",
			noremap = true,
			silent = true,
		},
	},
}
