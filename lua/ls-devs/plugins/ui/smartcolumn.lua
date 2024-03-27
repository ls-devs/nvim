return {
	"m4xshen/smartcolumn.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		colorcolumn = "100",
		disabled_filetypes = {
			"alpha",
			"NvimTree",
			"lazy",
			"mason",
			"help",
			"checkhealth",
			"lspinfo",
			"noice",
			"Trouble",
			"fish",
			"zsh",
		},
		scope = "file",
	},
}
