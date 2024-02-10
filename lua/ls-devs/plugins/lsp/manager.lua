return {
	-- Mason Installers (Formatters - LSPs - Lintters)
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	opts = {
		ensure_installed = {
			-- LSP
			"eslint",
			"astro",
			"tsserver",
			"html",
			"lemminx",
			"mdx_analyzer",
			"cssls",
			"cssmodules_ls",
			"emmet_language_server",
			"volar",
			"tailwindcss",
			"prismals",
			"jsonls",
			"intelephense",
			"sqlls",
			"yamlls",
			"dockerls",
			"docker_compose_language_service",
			"marksman",
			"rust_analyzer",
			"pyright",
			"cmake",
			"lua_ls",
			"clangd",
			"bashls",
			"vimls",
			"graphql",
			"wgsl_analyzer",
			"svelte",
			"taplo",
			"vls",
			"kotlin_language_server",

			-- Lintters
			"gitlint",
			"stylelint",
			"djlint",
			"jsonlint",
			"hadolint",
			"markdownlint",
			"cmakelint",
			"yamllint",
			"cpplint",
			"sqlfluff",
			"shellcheck",

			-- Formatters
			"prettierd",
			"mdformat",
			"cmakelang",
			"clang-format",
			"yq",
			"stylua",
			"gersemi",
			"black",
			"isort",
			"sql-formatter",
			"rustfmt",
			"shellharden",

			-- Debuggers
			"debugpy",
			"node-debug2-adapter",
			"bash-debug-adapter",
			"php-debug-adapter",
			"codelldb",
			"js-debug-adapter",
			"chrome-debug-adapter",
			"kotlin-debug-adapter",
		},

		auto_update = false,

		run_on_start = false,

		start_delay = 3000,

		debounce_hours = 5,
	},
	dependencies = {
		{
			-- Mason LSPs
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup_handlers({
					function(server)
						require("lspconfig")[server].setup({
							capabilities = require("cmp_nvim_lsp").default_capabilities(),
						})
					end,
					rust_analyzer = function() end,
					tsserver = function() end,
				})

				for _, server in pairs(require("mason-lspconfig").get_installed_servers()) do
					local has_config, config = pcall(require, "ls-devs.plugins.lsp.servers_settings." .. server)
					if has_config then
						require("lspconfig")[server].setup(vim.tbl_deep_extend("force", config, {
							capabilities = require("cmp_nvim_lsp").default_capabilities(),
						}))
					end
				end
			end,
			dependencies = {
				{
					"williamboman/mason.nvim",
					opts = {
						log_level = vim.log.levels.OFF,
						ui = {
							border = "rounded",
							icons = {
								package_installed = "✓",
								package_pending = "➜",
								package_uninstalled = "✗",
							},
						},
					},
				},
				{
					"neovim/nvim-lspconfig",
					init = function()
						vim.lsp.set_log_level("OFF")
						require("lspconfig.ui.windows").default_options.border = "rounded"
						vim.diagnostic.config({
							virtual_text = false,
							update_in_insert = false,
							underline = true,
							severity_sort = true,
							signs = {
								priority = 1,
								text = {
									[vim.diagnostic.severity.ERROR] = " ",
									[vim.diagnostic.severity.WARN] = " ",
									[vim.diagnostic.severity.INFO] = " ",
									[vim.diagnostic.severity.HINT] = " ",
								},
							},
							float = {
								focusable = true,
								style = "minimal",
								border = "rounded",
								source = "always",
								header = "",
								prefix = "",
							},
						})
					end,
				},
			},
		},
	},
}
