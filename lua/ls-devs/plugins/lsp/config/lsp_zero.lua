return function()
	vim.lsp.set_log_level("OFF")

	local lsp_zero = require("lsp-zero")
	require("lspconfig.ui.windows").default_options.border = "rounded"

	vim.diagnostic.config({
		virtual_text = false,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		signs = {
			priority = 1,
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",
			},
		},
		float = {
			focusable = true,
			style = "minmal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	-- Lsp-Zero default config
	lsp_zero.on_attach(function(client, bufnr)
		-- Disable all formatting capabilities and only use EFM
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		lsp_zero.default_keymaps({ buffer = bufnr })
	end)

	-- Per-server custom config
	local get_servers = require("mason-lspconfig").get_installed_servers
	for _, server in pairs(get_servers()) do
		local has_config, config = pcall(require, "ls-devs.plugins.lsp.servers_settings." .. server)
		if has_config then
			require("lspconfig")[server].setup(config)
		end
	end

	-- Efm formatting config
	local languages = require("ls-devs.plugins.lsp.config.efm_configs").languages
	require("lspconfig").efm.setup({
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = true
			client.server_capabilities.documentRangeFormattingProvider = true
		end,
		filetypes = vim.tbl_keys(languages),
		settings = {
			rootMarkers = { ".git/" },
			languages = languages,
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
	})
end
