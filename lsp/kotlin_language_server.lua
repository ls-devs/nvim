-- ── lsp/kotlin_language_server ────────────────────────────────────────────
-- Server  : kotlin-language-server
-- Language: Kotlin
-- Config  : Formatting disabled via on_attach capability override
-- Note    : Formatting handled by conform (ktlint)
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client)
		-- Disable server-side formatting; conform/ktlint owns Kotlin formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
