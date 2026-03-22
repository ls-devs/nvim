-- ── lsp/lua_ls ────────────────────────────────────────────────────────────
-- Server  : lua-language-server (lua_ls)
-- Language: Lua
-- Config  : "vim", "require", and "Snacks" declared as known globals
-- Note    : Suppresses "undefined-global" warnings in Neovim config files.
--           Loaded automatically by Neovim 0.11's lsp/ convention when
--           mason-lspconfig calls vim.lsp.enable("lua_ls").
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		Lua = {
			diagnostics = {
				-- Neovim injects `vim` and `require`; snacks.nvim injects `Snacks`.
				-- Declaring them here suppresses undefined-global warnings for the
				-- whole config without needing per-file ---@diagnostic disable lines.
				globals = { "vim", "require", "Snacks" },
			},
		},
	},
}
