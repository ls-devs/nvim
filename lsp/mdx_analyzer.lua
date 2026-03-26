-- ── lsp/mdx_analyzer ─────────────────────────────────────────────────────
-- Server  : mdx-analyzer
-- Language: MDX
-- Config  : Formatting disabled via on_attach capability override
-- Note    : Formatting handled by conform (prettierd)
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- prettierd via conform owns MDX formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
