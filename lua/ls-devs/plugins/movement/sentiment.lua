-- ── sentiment.nvim ────────────────────────────────────────────────────────
-- Purpose : Enhanced bracket-match highlighting that replaces built-in matchparen
-- Trigger : event — BufReadPost
-- Note    : loaded_matchparen must be set in init (before plugin loads) to
--           prevent the built-in matchparen from claiming the highlight group
-- ─────────────────────────────────────────────────────────────────────────
return {
	"utilyre/sentiment.nvim",
	event = "BufReadPost",
	init = function()
		vim.g.loaded_matchparen = 1 -- block built-in matchparen so sentiment can own bracket highlighting
	end,
}
