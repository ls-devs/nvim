return {
	-- Mason Installers (Formatters - LSPs - Lintters)
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	opts = {
		ensure_installed = {
			-- LSP
			"eslint",
			"astro",
			"vim-language-server",
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
			-- Mason
			"williamboman/mason-lspconfig.nvim",
			opts = {
				handlers = {
					function(server_name)
						local has_config, config =
							pcall(require, "ls-devs.plugins.lsp.servers_settings." .. server_name)
						if has_config then
							require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", config, {
								capabilities = require("cmp_nvim_lsp").default_capabilities(),
							}))
							require("lspconfig")[server_name].setup({
								capabilities = require("cmp_nvim_lsp").default_capabilities(),
							})
						end
					end,
					["lua_ls"] = function()
						require("neodev").setup({
							library = {
								enabled = true,
								runtime = true,
								types = true,
								plugins = {
									"lazy.nvim",
									"mason.nvim",
									"mason-lspconfig.nvim",
									"mason-tool-installer.nvim",
									"nvim-lspconfig",
									"lspsaga.nvim",
									"nvim-treesitter",
									"nvim-cmp",
									"conform.nvim",
									"nvim-lint",
									"noice.nvim",
									"neo-tree.nvim",
									"telescope.nvim",
									"legendary.nvim",
									"toggleterm.nvim",
									"tokyonight.nvim",
									"plenary.nvim",
									"neodev.nvim",
									"neotest",
								},
							},
							setup_jsonls = true,
							override = function(root_dir, options) end,
							lspconfig = true,
							pathStrict = true,
						})
						require("lspconfig")["lua_ls"].setup({
							capabilities = require("cmp_nvim_lsp").default_capabilities(),
							settings = {
								Lua = {
									completion = {
										callSnippet = "Replace",
									},
								},
							},
						})
					end,
					["rust_analyzer"] = function() end,
					["tsserver"] = function() end,
				},
			},
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
								border = "rounded",
								source = "always",
							},
						})
					end,
				},
			},
		},
	},
}
