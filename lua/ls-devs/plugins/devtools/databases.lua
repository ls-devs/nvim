-- ── vim-dadbod-ui ─────────────────────────────────────────────────────────
-- Purpose : Interactive database UI for querying SQL databases
-- Trigger : cmd = DBUI / DBUIToggle / DBUIAddConnection / DBUIFindBuffer
-- Provides: Connection manager, query buffers, result viewer
-- Note    : vim-dadbod is the backend driver; vim-dadbod-completion adds
--           SQL autocomplete restricted to sql/mysql/plsql filetypes only
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_winwidth = 45 -- sidebar width in columns
	end,
}
