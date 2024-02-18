return {
	"nvim-focus/focus.nvim",
	event = "VeryLazy",
	opts = {
		enable = true,
		commands = true,
		split = {
			bufnew = false,
			tmux = false,
		},
		autoresize = {
			enable = true,
			width = 0,
			height = 0,
			minwidth = 0,
			minheight = 0,
			height_quickfix = 10,
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
