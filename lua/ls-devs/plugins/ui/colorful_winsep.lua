return {
	"nvim-zh/colorful-winsep.nvim",
	event = { "WinNew" },
	opts = {
		hi = {
			fg = "#f5e0dc",
		},
		no_exec_files = {
			"packer",
			"TelescopePrompt",
			"mason",
			"CompetiTest",
			"NvimTree",
			"OverseerList",
			"DiffviewFiles",
		},
		symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
		smooth = false,
		anchor = {
			left = { height = 1, x = -1, y = -1 },
			right = { height = 1, x = -1, y = 0 },
			up = { width = 0, x = -1, y = 0 },
			bottom = { width = 0, x = 1, y = 0 },
		},
	},
}
