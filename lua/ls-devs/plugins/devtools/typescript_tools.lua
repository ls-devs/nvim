return {
	"pmizio/typescript-tools.nvim",
	event = {
		"BufRead *.js,*.jsx,*.mjs,*.cjs,*ts,*tsx",
		"BufNewFile *.js,*.jsx,*.mjs,*.cjs,*ts,*tsx",
	},
	opts = {
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
		settings = {
			code_lens = "all",
			disable_member_code_lens = false,
			expose_as_code_action = "all",
		},
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "neovim/nvim-lspconfig", lazy = true },
	},
}
