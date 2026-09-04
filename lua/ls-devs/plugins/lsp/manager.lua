-- ── manager ───────────────────────────────────────────────────────────────
-- Purpose : Tooling hub — Mason package installer, mason-lspconfig bridge,
--           and nvim-lspconfig global diagnostics setup
-- Trigger : MasonTools* commands (installer); BufReadPre / BufNewFile (lspconfig)
-- ──────────────────────────────────────────────────────────────────────────
---@type LazySpec[]
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
				"vim-language-server",
				"typescript-language-server",
				"vue-language-server",
				"html",
				"lemminx",
				"mdx_analyzer",
				"cssls",
				"cssmodules_ls",
				"css-variables-language-server",
				"somesass_ls",
				"emmet_language_server",
				"tailwindcss",
				"jsonls",
				"sqlls",
				"yamlls",
				"dockerls",
				"docker_compose_language_service",
				"marksman",
				"pyright",
				"lua_ls",
				"bashls",
				"vimls",
				"taplo",
				"omnisharp",
				"powershell_es",
				"clangd",

				-- ── Linters ───────────────────────────────────────────────────────
				-- eslint_d: fast daemon for ESLint diagnostics (nvim-lint).
				-- The eslint LSP is kept but its publishDiagnostics is suppressed
				-- so it only contributes code actions (Fix all, inline fixes).
				"eslint_d",
				"gitlint",
				"djlint",
				"jsonlint",
				"hadolint",
				"yamllint",
				"ruff",
				"shellcheck",
				"codespell",
				"stylelint",

				-- ── Formatters ────────────────────────────────────────────────────
				"prettierd",
				"markdownlint-cli2",
				"yq",
				"stylua",
				"black",
				"sql-formatter",
				"csharpier",
				"shellharden",
				"clang-format",

				-- ── Debuggers (DAP adapters) ──────────────────────────────────────
				"debugpy",
				"bash-debug-adapter",
				"js-debug-adapter",
			},
			-- NOTE: this plugin is cmd-lazy on purpose (see `cmd` above), so it
			-- never loads at startup. `run_on_start`, `start_delay`,
			-- `debounce_hours` and `auto_update` would therefore never fire and
			-- have been removed as dead config. Run `:MasonToolsInstall` (or
			-- `:MasonToolsUpdate`) after changing `ensure_installed`.
			-- Disable mason-null-ls integration (not installed) to avoid failed pcall on startup
			integrations = {
				["mason-null-ls"] = false,
				["mason-nvim-dap"] = false,
			},
		},
	},
	-- Mason LSP Configuration
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			automatic_enable = {
				-- typescript-tools manages its own LSP client directly via tsserver;
				-- neither ts_ls nor vtsls should attach alongside it.
				exclude = { "ts_ls", "vtsls" },
			},
		},
		dependencies = {
			-- Mason Core
			{
				"mason-org/mason.nvim",
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
						-- Disable slow on-open outdated check (auto_update handles updates already)
						check_outdated_packages_on_open = false,
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
						-- Virtual text is off; lspsaga and tiny-inline-diagnostic handle diagnostic display
						virtual_text = false,
						-- Avoid diagnostic flicker while typing
						update_in_insert = false,
						underline = true,
						severity_sort = true,
						signs = {
							-- Higher than gitsigns (sign_priority=1) so diagnostic
							-- signs always win when both appear on the same line.
							priority = 20,
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
				end,
			},
			{
				"b0o/schemastore.nvim",
				lazy = true,
				config = function()
					-- Wire JSON/YAML schema validation and completion through schemastore
					vim.lsp.config("jsonls", {
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
					vim.lsp.config("yamlls", {
						settings = {
							yaml = {
								schemaStore = { enable = false, url = "" },
								schemas = require("schemastore").yaml.schemas(),
							},
						},
					})
				end,
			},
			-- mason-nvim-dap bridges Mason-installed adapters with nvim-dap,
			-- auto-registering dap.adapters entries for all installed DAP packages.
			{
				"jay-babu/mason-nvim-dap.nvim",
				lazy = true,
				opts = {
					-- Auto-install adapters that are in Mason ensure_installed but
					-- not yet installed as DAP adapters.
					automatic_installation = true,
				},
			},
		},
	},
}
