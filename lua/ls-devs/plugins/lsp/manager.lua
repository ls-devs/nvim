-- ── manager ───────────────────────────────────────────────────────────────
-- Purpose : Tooling hub — Mason package installer, mason-lspconfig bridge,
--           and nvim-lspconfig global diagnostics setup
-- Trigger : MasonTools* commands (installer); BufReadPre / BufNewFile (lspconfig)
-- ──────────────────────────────────────────────────────────────────────────
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
				-- ── LSP servers ───────────────────────────────────────────────────
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
				"kotlin_language_server",
				"omnisharp",

				-- ── Linters ───────────────────────────────────────────────────────
				"gitlint",
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

				-- ── Formatters ────────────────────────────────────────────────────
				"prettierd",
				"markdownlint-cli2",
				"cmakelang",
				"clang-format",
				"yq",
				"stylua",
				"gersemi",
				"black",
				"sql-formatter",
				"csharpier",
				"shellharden",

				-- ── Debuggers (DAP adapters) ──────────────────────────────────────
				"debugpy",
				"bash-debug-adapter",
				"php-debug-adapter",
				"codelldb",
				"js-debug-adapter",
				"kotlin-debug-adapter",
			},
			auto_update = true,
			run_on_start = true,
			-- Defer installation 3 s after startup to avoid slowing initial load
			start_delay = 3000,
			-- Skip the update check if one already ran within the last 5 hours
			debounce_hours = 5,
		},
	},
	-- Mason LSP Configuration
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			automatic_installation = false,
			automatic_enable = {
				-- ts_ls is managed by typescript-tools.nvim; auto-enabling it
				-- here would create a conflicting second client on TS/JS files
				exclude = { "ts_ls" },
			},
		},
		dependencies = {
			-- Mason Core
			{
				"williamboman/mason.nvim",
				cmd = "Mason",
				lazy = true,
				opts = {
					-- Suppress mason.nvim's verbose log output
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
					-- vim.lsp.log.set_level("OFF")
					require("lspconfig.ui.windows").default_options.border = "rounded"
					vim.diagnostic.config({
						-- Virtual text is off; lspsaga and diagflow handle diagnostic display
						virtual_text = false,
						-- Avoid diagnostic flicker while typing
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
				end,
			},
			{ "b0o/schemastore.nvim", lazy = true },
		},
	},
}
