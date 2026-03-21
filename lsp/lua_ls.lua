-- ── lsp/lua_ls ────────────────────────────────────────────────────────────
-- Server  : lua-language-server (lua_ls)
-- Language: Lua
-- Config  : "vim" and "require" declared as known globals
-- Note    : Suppresses "undefined-global" warnings in Neovim config files
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		Lua = {
			diagnostics = {
				-- Neovim injects `vim` and `require` into the Lua runtime; declare
				-- them here so lua_ls doesn't flag them as undefined globals
				globals = { "vim", "require" },
			},
		},
	},
}
