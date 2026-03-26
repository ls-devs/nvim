-- ── lsp/taplo ─────────────────────────────────────────────────────────────
-- Server  : taplo (TOML language server)
-- Language: TOML
-- Config  : Formatting disabled via on_attach capability override
-- Note    : Formatting handled by conform (taplo CLI).
--           The taplo LSP and the taplo CLI formatter are the same binary but
--           disabling the LSP formatter prevents double-format on <leader>fm.
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- taplo CLI via conform owns TOML formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
