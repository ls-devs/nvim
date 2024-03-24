return {
	"zeioth/garbage-day.nvim",
	dependencies = "neovim/nvim-lspconfig",
	event = "LspAttach",
	opts = {
		excluded_lsp_clients = { "typescript-tools", "tsserver" },
	},
}
