-- ── lsp/lemminx ───────────────────────────────────────────────────────────
-- Server  : LeMMinX XML language server (lemminx)
-- Language: XML
-- Config  : Formatting disabled via on_attach capability override
-- Note    : Formatting handled by conform (prettierd)
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- prettierd via conform owns XML formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
