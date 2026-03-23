-- ── mini.surround ─────────────────────────────────────────────────────────
-- Purpose : Add, delete, replace, and highlight surrounding text objects
-- Trigger : keys — gz (n/v)
-- Note    : Remapped from default sa/sd prefix to gz* to avoid conflicts;
--           gza=add, gzd=delete, gzf=find, gzF=find-left, gzh=highlight,
--           gzr=replace, gzn=update n_lines
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"echasnovski/mini.surround",
	opts = {
		mappings = {
			add = "gza",
			delete = "gzd",
			find = "gzf",
			find_left = "gzF",
			highlight = "gzh",
			replace = "gzr",
			update_n_lines = "gzn",
		},
	},
	keys = { { "gz", mode = { "n", "v" }, desc = "Surround", noremap = true, silent = true } },
}
