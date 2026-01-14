return {
	"stevearc/overseer.nvim",
	opts = {
		form = {
			border = "rounded",
			win_opts = {
				winblend = 0,
			},
		},
		task_win = {
			border = "rounded",
			win_opts = {
				winblend = 0,
			},
		},
		task_list = {
			bindings = {
				["?"] = "ShowHelp",
				["g?"] = "ShowHelp",
				["<CR>"] = "RunAction",
				["<C-e>"] = "Edit",
				["o"] = "Open",
				["<C-v>"] = "OpenVsplit",
				["<C-s>"] = "OpenSplit",
				["<C-f>"] = "OpenFloat",
				["<C-q>"] = "OpenQuickFix",
				["p"] = "TogglePreview",
				["<C-o>"] = "IncreaseDetail",
				["<C-c>"] = "DecreaseDetail",
				["L"] = "IncreaseAllDetail",
				["H"] = "DecreaseAllDetail",
				["["] = "DecreaseWidth",
				["]"] = "IncreaseWidth",
				["{"] = "PrevTask",
				["}"] = "NextTask",
				["<C-k>"] = "ScrollOutputUp",
				["<C-j>"] = "ScrollOutputDown",
			},
		},
	},
	keys = {
		{
			"<leader>or",
			"<cmd>OverseerRun<CR>",
			desc = "Overseer Run",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ot",
			"<cmd>OverseerToggle left<CR>",
			desc = "Overseer Toggle",
			noremap = true,
			silent = true,
		},
	},
}
