-- ── lsp/bashls ────────────────────────────────────────────────────────────
-- Server  : bash-language-server (bashls)
-- Language: Bash / sh
-- Config  : Formatting disabled via on_attach capability override
-- Note    : Formatting handled by conform (shellharden)
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- shellharden via conform owns shell formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
