return {
	"glepnir/lspsaga.nvim",
	event = "LspAttach",
	opts = require("ls-devs.plugins.lsp.config.lspsaga"),
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
}
