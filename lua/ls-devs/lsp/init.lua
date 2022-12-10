local mason = require("mason")

if not mason then
	return
end
require("lspconfig.ui.windows").default_options.border = "rounded"

mason.setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local m = require("mason-lspconfig")

if not m then
	return
end

local lspconfig = require("lspconfig")

if not lspconfig then
	return
end

m.setup({
	ensure_installed = {
		"sumneko_lua",
		"jsonls",
		"tsserver",
		"eslint",
		"prismals",
		"tailwindcss",
		"html",
		"cssls",
		"marksman",
		"dockerls",
		"cssmodules_ls",
		"volar",
		"dockerls",
		"emmet_ls",
		"yamlls",
		"sqlls",
		"pyright",
		"clangd",
		"rust_analyzer",
		"intelephense",
	},
})

require("ls-devs.lsp.config")

local cmp_nvim_lsp = require("cmp_nvim_lsp")

if not cmp_nvim_lsp then
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local opts = {
	capabilities = capabilities,
	on_attach = require("ls-devs.lsp.on_attach").on_attach,
}

local typescript = require("typescript")

if not typescript then
	return
end

m.setup_handlers({
	function(server_name)
		local has_custom_opts, custom_opts = pcall(require, "ls-devs.lsp.settings." .. server_name)

		if has_custom_opts then
			opts = vim.tbl_deep_extend("force", custom_opts, opts)
		end

		lspconfig[server_name].setup(opts)
	end,
})
