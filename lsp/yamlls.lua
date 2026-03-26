-- ── lsp/yamlls ────────────────────────────────────────────────────────────
-- Server  : yaml-language-server (yamlls)
-- Language: YAML
-- Config  : YAML schemas from schemastore.nvim; formatting disabled
-- Note    : yq via conform.nvim owns YAML formatting.
--           schemaStore.enable=false prevents the built-in catalog from
--           conflicting with the schemas provided by schemastore.nvim.
-- ──────────────────────────────────────────────────────────────────────────
return {
	on_attach = function(client, _bufnr)
		-- yq via conform owns YAML formatting
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		yaml = {
			schemaStore = {
				-- Disable the built-in schema fetcher; schemastore.nvim provides
				-- a more complete and up-to-date catalog below
				enable = false,
				url = "",
			},
			schemas = require("schemastore").yaml.schemas(),
			validate = { enable = true },
		},
	},
}
