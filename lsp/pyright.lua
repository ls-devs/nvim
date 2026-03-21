-- ── lsp/pyright ───────────────────────────────────────────────────────────
-- Server  : pyright
-- Language: Python
-- Config  : Workspace-wide diagnostics, library type inference enabled
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				-- Analyze all Python files in the workspace, not just open buffers
				diagnosticMode = "workspace",
				-- Infer types from installed library source when .pyi stubs are absent
				useLibraryCodeForTypes = true,
			},
		},
	},
}
