-- ── lsp/sqlls ─────────────────────────────────────────────────────────────
-- Server  : sql-language-server (sqlls)
-- Language: SQL
-- Config  : Formatting disabled via on_attach capability override
-- Note    : Formatting handled by conform (sql-formatter)
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- sql-formatter via conform owns SQL formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
