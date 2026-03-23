-- ── lsp/lua_ls ────────────────────────────────────────────────────────────
-- Server  : lua-language-server (lua_ls)
-- Language: Lua
-- Config  : "vim" and "Snacks" declared as known globals
-- Note    : Suppresses "undefined-global" warnings in Neovim config files.
--           Loaded automatically by Neovim 0.11's lsp/ convention when
--           mason-lspconfig calls vim.lsp.enable("lua_ls").
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		Lua = {
			diagnostics = {
				-- Neovim injects `vim`; snacks.nvim injects `Snacks`.
				-- NOTE: `require` is a Lua built-in — do NOT add it here; doing so
				-- makes lua_ls register a second untyped _G.require(modname: any)
				-- that duplicates the stdlib signature in hover docs.
				globals = { "vim", "Snacks" },
			},
		},
	},
}
