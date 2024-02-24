return {
	"nvim-zh/colorful-winsep.nvim",
	event = { "WinNew" },
	opts = {
		interval = 30,
		no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree", "OverseerList" },
		symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
		close_event = function() end,
		hi = {
			fg = "#f5e0dc",
		},
	},
}
