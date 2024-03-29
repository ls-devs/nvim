return {
	"vidocqh/data-viewer.nvim",
	ft = { "tsv", "csv", "sqlite" },
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "kkharji/sqlite.lua", lazy = true },
	},
	opts = {
		autoDisplayWhenOpenFile = false,
		maxLineEachTable = 100,
		columnColorEnable = true,
		columnColorRoulette = { -- Highlight groups
			"DataViewerColumn0",
			"DataViewerColumn1",
			"DataViewerColumn2",
		},
		view = {
			width = 0.8, -- Less than 1 means ratio to screen width
			height = 0.8, -- Less than 1 means ratio to screen height
			zindex = 50,
		},
		keymap = {
			quit = "q",
			next_table = "<C-l>",
			prev_table = "<C-h>",
		},
	},
}
