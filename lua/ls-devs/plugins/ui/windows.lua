return {
	"anuvyklack/windows.nvim",
	event = { "BufReadPost", "BufNewFile" },
	init = function()
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		vim.o.equalalways = false
	end,
	opts = {
		autowidth = {
			enable = true,
			winwidth = 5,
			filetype = {
				help = 2,
			},
		},
		ignore = {
			buftype = { "quickfix" },
			filetype = {
				"NvimTree",
				"neo-tree",
				"undotree",
				"gundo",
				"Diffview",
				"DiffviewFiles",
				"terminal",
				"toggleterm",
				"neotest-summary",
				"OverseerList",
				"Overseer",
			},
		},
	},
	dependencies = {
		{ "anuvyklack/middleclass", lazy = true },
	},
	keys = {
		{
			"<leader>wm",
			":WindowsMaximize<CR>",
			desc = "Maximize Windows",
			silent = true,
			noremap = true,
		},
		{
			"<leader>wv",
			":WindowsMaximizeVertically<CR>",
			desc = "Maximize Windows Vertically",
			silent = true,
			noremap = true,
		},
		{
			"<leader>wh",
			":WindowsMaximizeHorizontally<CR>",
			desc = "Maximize Windows Horizontally",
			silent = true,
			noremap = true,
		},
		{
			"<leader>wt",
			":WindowsToggleAutowidth<CR>",
			desc = "Toggle Windows AutoWidth",
			silent = true,
			noremap = true,
		},
		{
			"<leader>we",
			":WindowsEqualize<CR>",
			desc = "Equalize Window",
			silent = true,
			noremap = true,
		},
	},
}
