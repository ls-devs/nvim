return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			title_pos = "center",
			enabled = true,
			start_in_insert = true,
			insert_only = false,
			relative = "editor",
			mappings = {
				n = {
					["<Esc>"] = "Close",
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
				},
				i = {
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
					["<Up>"] = "HistoryPrev",
					["<Down>"] = "HistoryNext",
				},
			},
		},
		nui = {
			relative = "editor",
		},
		select = {
			enabled = true,
		},
		builtin = {
			relative = "editor",
		},
	},
}
