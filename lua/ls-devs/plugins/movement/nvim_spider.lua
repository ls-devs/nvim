-- ── nvim-spider ───────────────────────────────────────────────────────────
-- Purpose : Smarter w/e/b motions that stop at camelCase and subword boundaries
-- Trigger : keys — w, e, b, cw (n/o/x)
-- Note    : cw uses c+spider-e so it changes to end of the current subword,
--           matching Vim's intended cw semantics with subword granularity
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"chrisgrieser/nvim-spider",
	-- luarocks.nvim provides the `lua-utf8` rock that nvim-spider needs for
	-- UTF-8-aware motions. It has no trigger of its own, so without declaring it
	-- here it never loads and spider silently falls back to byte-wise strings.
	dependencies = { "vhyrro/luarocks.nvim" },
	opts = {
		skipInsignificantPunctuation = true, -- skip lone punctuation chars (., ;, ,) that aren't real word boundaries
		subwordMovement = true, -- stop at camelCase transitions and underscore separators
		customPatterns = {},
	},
	keys = {
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider w",
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider e",
		},
		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider b",
		},
		{
			"cw",
			"c<cmd>lua require('spider').motion('e')<CR>",
			mode = "n",
			desc = "Spider cw (change subword)",
		},
	},
}
