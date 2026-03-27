-- ── typescript-tools.nvim ────────────────────────────────────────────────
-- Purpose : High-performance TypeScript/JavaScript LSP that communicates
--           directly with tsserver (same protocol as VS Code), bypassing
--           typescript-language-server's proxy layer.
-- Trigger : ft — only loads for TS/JS files
-- Note    : This plugin manages its own LSP client; do NOT configure ts_ls
--           or vtsls alongside it. Mason only needs typescript installed,
--           not typescript-language-server.
--           Formatting is handled by prettierd via conform.nvim.
--           Semantic tokens disabled — treesitter + catppuccin owns colours.
--           Sends $/progress → fidget spinner works.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"pmizio/typescript-tools.nvim",
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = function()
		local api = require("typescript-tools.api")

		require("typescript-tools").setup({
			on_attach = function(client, bufnr)
				-- prettierd owns formatting
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				-- treesitter + catppuccin owns colours
				client.server_capabilities.semanticTokensProvider = nil

				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end

				local map = function(key, fn, desc)
					vim.keymap.set("n", key, fn, { buffer = bufnr, noremap = true, silent = true, desc = desc })
				end

				map("<leader>cO", "<cmd>TSToolsOrganizeImports<cr>", "TS Organize Imports")
				map("<leader>cI", "<cmd>TSToolsAddMissingImports<cr>", "TS Add Missing Imports")
				map("<leader>cU", "<cmd>TSToolsRemoveUnusedImports<cr>", "TS Remove Unused Imports")
				map("<leader>cF", "<cmd>TSToolsFixAll<cr>", "TS Fix All")
				map("<leader>cR", "<cmd>TSToolsFileReferences<cr>", "TS File References")
				map("<leader>cM", "<cmd>TSToolsRenameFile<cr>", "TS Rename File")
				map("gD", "<cmd>TSToolsGoToSourceDefinition<cr>", "TS Go to Source Definition")
				map("<leader>ch", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
				end, "TS Toggle Inlay Hints")
			end,

			handlers = {
				-- Filter noisy diagnostics that don't add value
				["textDocument/publishDiagnostics"] = api.filter_diagnostics({
					80006, -- "This may be converted to an async function"
				}),
			},

			settings = {
				-- Separate tsserver instance for diagnostics so editing stays snappy
				separate_diagnostic_server = true,
				-- Only re-compute diagnostics on leaving insert mode (not on every keystroke)
				publish_diagnostic_on = "insert_leave",
				-- Expose these as proper code actions in the picker as well
				expose_as_code_action = {
					"fix_all",
					"add_missing_imports",
					"remove_unused",
					"remove_unused_imports",
					"organize_imports",
				},
				-- Use the workspace TypeScript installation when available
				tsserver_path = nil,
				-- No memory cap — "auto" lets Node manage it; fine for most projects
				tsserver_max_memory = "auto",
				-- Complete function calls with () and snippet placeholders
				complete_function_calls = true,
				include_completions_with_insert_text = true,
				-- Code lens off — experimental and adds server load
				code_lens = "off",
				disable_member_code_lens = true,
				-- nvim-ts-autotag handles JSX tag closing
				jsx_close_tag = { enable = false },

				tsserver_file_preferences = {
					-- Inlay hints
					includeInlayParameterNameHints = "literals",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
					-- Auto-imports
					importModuleSpecifierPreference = "shortest",
					importModuleSpecifierEnding = "auto",
					quotePreference = "single",
					includeCompletionsForModuleExports = true,
					includeCompletionsForImportStatements = true,
					includeAutomaticOptionalChainCompletions = true,
					allowTextChangesInNewFiles = true,
					-- Update imports when file is moved/renamed
					providePrefixAndSuffixTextForRename = true,
					allowRenameOfImportPath = true,
				},

				tsserver_format_options = {
					allowIncompleteCompletions = true,
					allowRenameOfImportPath = true,
				},
			},
		})
	end,
}
