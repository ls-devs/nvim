-- ── lsp/volar ─────────────────────────────────────────────────────────────
-- Server  : vue-language-server (Volar v2) — official Vue Language Server.
-- Role    : Vue SFC support (.vue files): template, script, style blocks,
--           TypeScript type checking, component props/emits/slots.
-- Note    : Formatting disabled — prettierd via conform.nvim handles it.
--           vtsls handles .ts/.tsx alongside this server.
-- ──────────────────────────────────────────────────────────────────────────
---@type vim.lsp.Config
return {
	filetypes = { "vue" },
	on_attach = function(client)
		-- prettierd owns formatting — disable volar formatter to avoid conflicts.
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	init_options = {
		vue = {
			hybridMode = false,
		},
	},
}
