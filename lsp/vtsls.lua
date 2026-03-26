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

		-- vtsls sends _typescript.didOrganizeImports as a server→client command
		-- callback after organize imports completes. Register a no-op handler
		-- once to silence the "command not supported" error.
		vim.lsp.commands["_typescript.didOrganizeImports"] = vim.lsp.commands["_typescript.didOrganizeImports"]
			or function() end

		-- vtsls exposes import management as source code actions, not as
		-- workspace/executeCommand entries. Using code_action with apply=true
		-- auto-applies the single matching action without showing a picker.
		local function ts_action(kinds, label)
			vim.lsp.buf.code_action({
				context = { only = kinds, diagnostics = {} },
				apply = true,
				filter = function(action)
					-- Accept any action whose kind starts with one of our kinds
					for _, k in ipairs(kinds) do
						if (action.kind or ""):find(k, 1, true) == 1 then
							return true
						end
					end
					return false
				end,
			})
			vim.notify(label, vim.log.levels.INFO, { title = "vtsls" })
		end

		map("<leader>cO", function()
			ts_action({ "source.organizeImports" }, "Imports organized")
		end, "TS Organize Imports")

		map("<leader>cI", function()
			ts_action({ "source.addMissingImports" }, "Missing imports added")
		end, "TS Add Missing Imports")

		map("<leader>cU", function()
			ts_action({ "source.removeUnused" }, "Unused imports removed")
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
