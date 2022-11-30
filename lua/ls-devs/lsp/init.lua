local mason = safe_require("mason")

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

local m = safe_require("mason-lspconfig")

if not m then
	return
end

local lspconfig = safe_require("lspconfig")

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
		"intelephense",
	},
})

require("ls-devs.lsp.config")

local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")

if not cmp_nvim_lsp then
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local opts = {
	capabilities = capabilities,
	on_attach = require("ls-devs.lsp.on_attach").on_attach,
}

local typescript = safe_require("typescript")

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
	["tsserver"] = function()
		typescript.setup({
			server = opts,
		})
	end,
})

require("lspconfig").yamlls.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").intelephense.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
  settings = {
        intelephense = {
            stubs = { 
                "bcmath",
                "bz2",
                "mysql",
                "psql",
                "calendar",
                "Core",
                "curl",
                "zip",
                "zlib",
                "wordpress",
                "woocommerce",
                "acf-pro",
                "wordpress-globals",
                "wp-cli",
                "genesis",
                "polylang"
            },
            environment = {
              includePaths = '/Users/laurent/.composer/vendor/php-stubs/' -- this line forces the composer path for the stubs in case inteliphense don't find it...
            },
            files = {
                maxSize = 5000000;
            };
        };
    }
})
require("lspconfig").dockerls.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").sqlls.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").html.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").cssls.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").prismals.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").tailwindcss.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").eslint.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").emmet_ls.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").cssmodules_ls.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})
require("lspconfig").volar.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
})

require("lspconfig").pyright.setup({
	on_attach = opts.on_attach,
	capabilities = opts.capabilities,
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	settings = {
		python = {
			analysis = {
				extraPath = { "." },
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
	single_file_support = true,
})
