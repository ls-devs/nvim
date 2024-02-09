return {
	"hinell/lsp-timeout.nvim",
	event = "LspAttach",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	init = function()
		vim.g.lspTimeoutConfig = {
			stopTimeout = 1000 * 60 * 5, -- ms, timeout before stopping all LSPs
			startTimeout = 1000 * 3, -- ms, timeout before restart
			silent = false, -- true to suppress notifications
			filetypes = {
				ignore = { -- filetypes to ignore; empty by default
					"Overseer",
					"aerial",
				},
			},
		}
	end,
}
