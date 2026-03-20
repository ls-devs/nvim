return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		{
			"<leader>sr",
			function()
				require("grug-far").open()
			end,
			desc = "GrugFar Search & Replace",
			noremap = true,
			silent = true,
		},
		{
			"<leader>sw",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
			desc = "GrugFar Search Word",
			noremap = true,
			silent = true,
		},
	},
	opts = {
		headerMaxWidth = 80,
		windowCreationCommand = "vsplit",
		engine = "ripgrep",
		engines = {
			ripgrep = {
				extraArgs = "--max-depth 6 --one-file-system",
			},
		},
		spinnerStates = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
		icons = {
			enabled = true,
			fileIconsProvider = "nvim-web-devicons",
			actionEntryBullet = "  ",
			searchInput = "󰍉  ",
			replaceInput = "  ",
			filesFilterInput = "󰈙  ",
			flagsInput = "󰮕  ",
			pathsInput = "  ",
			resultsStatusReady = "󱩾  ",
			resultsStatusError = "  ",
			resultsStatusSuccess = "  ",
			resultsActionMessage = "  ",
			resultsChangeIndicator = "┃",
			resultsAddedIndicator = "▒",
			resultsRemovedIndicator = "▒",
			resultsDiffSeparatorIndicator = "┊",
			helpHintsHeader = "  ",
		},
	},
}
