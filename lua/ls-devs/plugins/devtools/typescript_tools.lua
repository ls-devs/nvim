return {
	"pmizio/typescript-tools.nvim",
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	opts = {
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	},
	dependencies = {
		{ "neovim/nvim-lspconfig", lazy = true },
	},
}
