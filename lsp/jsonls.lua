-- ── lsp/jsonls ────────────────────────────────────────────────────────────
-- Server  : vscode-json-language-server (jsonls)
-- Language: JSON, YAML
-- Config  : JSON and YAML schemas sourced from schemastore.nvim
-- Note    : Requires b0o/schemastore.nvim to be loaded before this config runs
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
		yaml = {
			schemaStore = {
				-- Disable the built-in schema fetcher so it doesn't conflict with
				-- the catalog provided by schemastore.nvim below
				enable = false,
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
