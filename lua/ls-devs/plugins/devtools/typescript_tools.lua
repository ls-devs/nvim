-- ── typescript-tools ─────────────────────────────────────────────────────
-- Purpose : Alternative TypeScript LSP that communicates directly with tsserver
-- Trigger : ft = javascript / javascriptreact / typescript / typescriptreact
-- Note    : Formatting disabled on the client — prettierd handles it via conform.nvim.
--           ts_ls stays in Mason ensure_installed so tsserver is locatable,
--           but ts_ls auto-enable is excluded in mason-lspconfig.
-- ─────────────────────────────────────────────────────────────────────────
return {
	"pmizio/typescript-tools.nvim",
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	opts = {
		on_attach = function(client)
			-- Disable tsserver's built-in formatting; prettierd handles it via conform.nvim.
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "neovim/nvim-lspconfig", lazy = true },
	},
}
