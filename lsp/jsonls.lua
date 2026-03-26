-- ── lsp/jsonls ────────────────────────────────────────────────────────────
-- Server  : vscode-json-language-server (jsonls)
-- Language: JSON
-- Config  : JSON schemas sourced from schemastore.nvim
-- Note    : Requires b0o/schemastore.nvim to be loaded before this config runs.
--           YAML schema config lives in lsp/yamlls.lua — not here.
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}
