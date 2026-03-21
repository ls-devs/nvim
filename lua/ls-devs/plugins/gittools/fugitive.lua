-- ── vim-fugitive ──────────────────────────────────────────────────────────
-- Purpose : Classic git command integration (:Git, :Gdiffsplit)
-- Trigger : cmd = { "Git", "Gdiffsplit", "Gvdiffsplit" }
-- ──────────────────────────────────────────────────────────────────────────
return {
	"tpope/vim-fugitive",
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
	cmd = {
		"Git",
		"Gdiffsplit",
		"Gvdiffsplit",
	},
}
