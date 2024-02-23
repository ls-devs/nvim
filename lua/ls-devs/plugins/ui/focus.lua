return {
	"nvim-focus/focus.nvim",
	event = { "BufReadPost", "BufNewFile" },
	lazy = true,
	opts = {
		enable = true,
		commands = true,
		split = {
			bufnew = false,
			tmux = false,
		},
		autoresize = {
			enable = true,
		},
		ui = {
			number = false,
			relativenumber = false,
			hybridnumber = false,
			absolutenumber_unfocussed = false,

			cursorline = false,
			cursorcolumn = false,
			colorcolumn = {
				enable = false,
			},
			signcolumn = false,
			winhighlight = false,
		},
	},
	keys = {
		{
			"<leader>wm",
			"<cmd>FocusMaximise<CR>",
			desc = "Focus Windows",
			silent = true,
			noremap = true,
		},
		{
			"<leader>we",
			"<cmd>FocusEqualise<CR>",
			desc = "Equalize Window",
			silent = true,
			noremap = true,
		},
		{
			"<leader>wr",
			"<cmd>FocusAutoresize<CR>",
			desc = "Equalize Window",
			silent = true,
			noremap = true,
		},
	},
}
