-- ── vim-matchup ───────────────────────────────────────────────────────────
-- Purpose : Enhanced bracket/keyword matching — replaces built-in matchparen
--           and matchit; adds g%, [%, ]%, z% motions and i%/a% text objects
-- Trigger : event — BufReadPost
-- Note    : matchup replaces matchparen automatically; no need to set
--           loaded_matchparen. Treesitter integration is enabled via
--           matchup = { enable = true } in treesitter.lua opts.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"andymass/vim-matchup",
	event = "BufReadPost",
	init = function()
		-- Show the matching off-screen keyword in a floating popup instead of
		-- the statusline (cleaner, doesn't clobber lualine)
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
		-- Enable ds%/cs% surround-style operations on match pairs
		vim.g.matchup_surround_enabled = 1
		-- Deferred highlighting keeps cursor snappy on large files
		vim.g.matchup_matchparen_deferred = 1
	end,
}
