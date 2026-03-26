-- ── lsp/vtsls ─────────────────────────────────────────────────────────────
-- Server  : vtsls (@vtsls/language-server) — VS Code's TypeScript extension
--           wrapped as a standalone LSP server. Replaces typescript-tools.nvim.
-- Role    : TypeScript / JavaScript language features for TS/JS/React files.
-- Note    : Formatting disabled — prettierd via conform.nvim handles it.
--           Inlay hints are enabled on attach (toggle with <leader>ch).
-- ──────────────────────────────────────────────────────────────────────────
---@type vim.lsp.Config
return {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	on_attach = function(client, bufnr)
		-- prettierd owns formatting — disable vtsls formatter to avoid conflicts.
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		-- Enable inlay hints for this buffer when the server supports them.
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- ── TS-specific keybinds (buffer-local, only active in TS/JS files) ──
		local map = function(key, fn, desc)
			vim.keymap.set("n", key, fn, { buffer = bufnr, noremap = true, silent = true, desc = desc })
		end
		local file = vim.api.nvim_buf_get_name(bufnr)

		map("<leader>cO", function()
			client:exec_cmd({ title = "Organize Imports", command = "typescript.organizeImports", arguments = { file } })
		end, "TS Organize Imports")

		map("<leader>cI", function()
			client:exec_cmd({
				title = "Add Missing Imports",
				command = "typescript.addMissingImports",
				arguments = { file },
			})
		end, "TS Add Missing Imports")

		map("<leader>cU", function()
			client:exec_cmd({
				title = "Remove Unused Imports",
				command = "typescript.removeUnusedImports",
				arguments = { file },
			})
		end, "TS Remove Unused Imports")

		map("<leader>ch", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end, "TS Toggle Inlay Hints")
	end,
	settings = {
		vtsls = {
			-- Pick up the project's own TypeScript version from node_modules.
			autoUseWorkspaceTsdk = true,
			-- Enable the "Move to File" refactoring code action.
			enableMoveToFileCodeAction = true,
			experimental = {
				-- Filter completions on the server — smaller, pre-ranked list
				-- sent to Neovim; noticeably faster in large codebases.
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
}
