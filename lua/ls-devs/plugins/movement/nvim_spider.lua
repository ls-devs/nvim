-- ── nvim-spider ───────────────────────────────────────────────────────────
-- Purpose : Smarter w/e/b motions that stop at camelCase and subword boundaries
-- Trigger : keys — w, e, b (n/o/x); cw remapped via init
-- Note    : cw uses c+spider-e so it changes to end of the current subword,
--           matching Vim's intended cw semantics with subword granularity
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"chrisgrieser/nvim-spider",
	opts = {
		skipInsignificantPunctuation = true, -- skip lone punctuation chars (., ;, ,) that aren't real word boundaries
		subwordMovement = true, -- stop at camelCase transitions and underscore separators
		customPatterns = {},
	},
	init = function()
		-- cw → c + spider-e: changes to end of current word; plain cw with spider-w would change to start of next word
		vim.keymap.set("n", "cw", "c<cmd>lua require('spider').motion('e')<CR>")
	end,
	keys = {
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
		},
		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
		},
	},
}
