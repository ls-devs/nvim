-- ── vim-fugitive ──────────────────────────────────────────────────────────
-- Purpose : Classic git command integration (:Git, :Gdiffsplit)
-- Trigger : cmd = { "Git", "Gdiffsplit", "Gvdiffsplit" }
-- ──────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"tpope/vim-fugitive",
	---@return boolean
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
	cmd = {
		"Git",
		"Gdiffsplit",
		"Gvdiffsplit",
	},
}
