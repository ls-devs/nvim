return {
	"m4xshen/smartcolumn.nvim",
	event = { "BufEnter", "BufNewFile" },
	opts = {
		colorcolumn = "100",
		disabled_filetypes = { "help", "lazy", "alpha", "mason" },
		scope = "file",
	},
}
