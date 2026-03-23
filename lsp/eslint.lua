-- ── lsp/eslint ────────────────────────────────────────────────────────────
-- Server  : vscode-eslint-language-server (eslint)
-- Role    : Code actions ONLY (Fix all, inline rule fixes, disable comments).
--           Diagnostics are handled by eslint_d via nvim-lint (linting.lua),
--           which is the daemon designed for that job.
-- Note    : Suppress publishDiagnostics so the LSP never writes to the
--           diagnostic namespace — eslint_d already owns that channel.
-- ──────────────────────────────────────────────────────────────────────────
return {
	handlers = {
		["textDocument/publishDiagnostics"] = function() end,
	},
}
