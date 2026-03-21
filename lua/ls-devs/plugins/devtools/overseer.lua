-- ── overseer ─────────────────────────────────────────────────────────────
-- Purpose : Task runner / build system overlay for Neovim
-- Trigger : cmd = OverseerRun / OverseerToggle / OverseerBuild / OverseerOpen / OverseerInfo
-- Note    : Task form and output windows use rounded borders (toggleterm-style)
-- ─────────────────────────────────────────────────────────────────────────
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
	cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild", "OverseerOpen", "OverseerInfo" },
	keys = {
		-- <leader>or — open the task picker and run a task
		{
			"<leader>or",
			"<cmd>OverseerRun<CR>",
			desc = "Overseer Run",
			noremap = true,
			silent = true,
		},
		-- <leader>ot — toggle the task list panel (docked left)
		{
			"<leader>ot",
			"<cmd>OverseerToggle left<CR>",
			desc = "Overseer Toggle",
			noremap = true,
			silent = true,
		},
	},
}
