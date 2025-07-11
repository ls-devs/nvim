return {
	-- Global Mason Installer (LSP | LINTERS | FORMATTERS | DAPS)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		cmd = {
			"MasonToolsInstall",
			"MasonToolsInstallSync",
			"MasonToolsUpdate",
			"MasonToolsUpdateSync",
			"MasonToolsClean",
		},
		opts = {
			ensure_installed = {
				-- LSP
				"eslint",
				"sonarlint-language-server",
				"jdtls",
				"astro",
				"vim-language-server",
				"ts_ls",
				"html",
				"lemminx",
				"mdx_analyzer",
				"cssls",
				"cssmodules_ls",
				"css-variables-language-server",
				"somesass_ls",
				"emmet_language_server",
				"vue_ls",
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
				"cmakelint",
				"yamllint",
				"cpplint",
				"sqlfluff",
				"ruff",
				"shellcheck",
				"ktlint",
				"codespell",

				-- Formatters
				"prettierd",
				"markdownlint-cli2",
				"cmakelang",
				"clang-format",
				"yq",
				"stylua",
				"gersemi",
				"black",
				"sql-formatter",
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
			auto_update = true,
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 5,
		},
	},
	-- Mason LSP Configuration
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			automatic_installation = false,
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
					})
				end,
				["cssls"] = function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
						settings = {
							css = {
								lint = {
									unknownAtRules = "ignore",
								},
							},
							scss = {
								lint = {
									unknownAtRules = "ignore",
								},
							},
							less = {
								lint = {
									unknownAtRules = "ignore",
								},
							},
						},
					})
				end,
				["tailwindcss"] = function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
						root_dir = require("lspconfig.util").root_pattern(
							"tailwind.config.js",
							"tailwind.config.cjs",
							"tailwind.config.mjs",
							"tailwind.config.ts"
						),
					})
				end,
				["kotlin_language_server"] = function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
						on_attach = function(client)
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end,
					})
				end,
				["jsonls"] = function(server_name)
					local schemastore = require("schemastore")
					require("lspconfig")[server_name].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
						settings = {
							json = {
								schemas = schemastore.json.schemas(),
								validate = { enable = true },
							},
							yaml = {
								schemaStore = {
									enable = false,
									url = "",
								},
								schemas = require("schemastore").yaml.schemas(),
							},
						},
					})
				end,
				["pyright"] = function(server_name)
					require("lspconfig")[server_name].setup({
						on_init = function(client)
							client.config.settings.python.pythonPath =
								require("ls-devs.utils.custom_functions").get_python_path(client.config.root_dir)
						end,
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
						settings = {
							python = {
								analysis = {
									autoSearchPaths = true,
									diagnosticMode = "workspace",
									useLibraryCodeForTypes = true,
								},
							},
						},
					})
				end,
				["intelephense"] = function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
						settings = {
							intelephense = {
								stubs = {
									"bcmath",
									"bz2",
									"Core",
									"curl",
									"date",
									"dom",
									"fileinfo",
									"filter",
									"gd",
									"gettext",
									"hash",
									"iconv",
									"imap",
									"intl",
									"json",
									"libxml",
									"mbstring",
									"mcrypt",
									"mysql",
									"mysqli",
									"password",
									"pcntl",
									"pcre",
									"PDO",
									"pdo_mysql",
									"Phar",
									"readline",
									"regex",
									"session",
									"SimpleXML",
									"sockets",
									"sodium",
									"standard",
									"superglobals",
									"tokenizer",
									"xml",
									"xdebug",
									"xmlreader",
									"xmlwriter",
									"yaml",
									"zip",
									"zlib",
									"wordpress-stubs",
									"woocommerce-stubs",
									"acf-pro-stubs",
									"wordpress-globals",
									"wp-cli-stubs",
									"genesis-stubs",
									"polylang-stubs",
								},
								environment = {
									includePaths = {
										vim.env.HOME .. "/.config/composer/vendor/php-stubs/",
										vim.env.HOME .. "/.config/composer/vendor/wpsyntex/",
									},
								},
								clearCache = true,
								files = {
									maxSize = 5000000,
								},
							},
						},
					})
				end,
				["rust_analyzer"] = function() end,
				["ts_ls"] = function() end,
			},
		},
		dependencies = {
			-- Mason Core
			{
				"williamboman/mason.nvim",
				cmd = "Mason",
				lazy = true,
				opts = {
					log_level = vim.log.levels.OFF,
					pip = {
						upgrade_pip = true,
					},
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
			-- LSP Configuration Core
			{
				"neovim/nvim-lspconfig",
				lazy = true,
				config = function()
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
								[vim.diagnostic.severity.ERROR] = "",
								[vim.diagnostic.severity.WARN] = "",
								[vim.diagnostic.severity.INFO] = "",
								[vim.diagnostic.severity.HINT] = "",
							},
						},
						float = {
							focusable = true,
							border = "rounded",
							source = true,
						},
					})
					vim.fn.sign_define("DiagnosticSignError", {
						text = " ",
					})
					vim.fn.sign_define("DiagnosticSignWarn", {
						text = " ",
					})
					vim.fn.sign_define("DiagnosticSignInfo", {
						text = " ",
					})
					vim.fn.sign_define("DiagnosticSignHint", {
						text = " ",
					})

					require("lspconfig")["sourcekit"].setup({
						capabilities = vim.tbl_deep_extend(
							"force",
							{},
							vim.lsp.protocol.make_client_capabilities(),
							require("cmp_nvim_lsp").default_capabilities()
						),
					})
				end,
			},
		},
	},
}
