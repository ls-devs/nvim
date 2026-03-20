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
		use_default_keymaps = false,
		check_syntax_error = true,
		max_join_length = 120,
		cursor_behavior = "hold",
		notify = true,
		dot_repeat = true,
	},
}
