-- ── multiple-cursors.nvim ─────────────────────────────────────────────────
-- Purpose : Multi-cursor editing with directional and match-based placement
-- Trigger : keys — <C-Up/Down>, <leader>cj/ck/ac/AC/cn/CN/lc
-- Note    : AC adds cursors at visible viewport matches; ac at all buffer matches;
--           CN jumps to next match without adding a cursor (navigate-only)
-- ─────────────────────────────────────────────────────────────────────────
return {
	"brenton-leighton/multiple-cursors.nvim",
	opts = {},
	keys = {
		{
			"<C-Down>",
			"<Cmd>MultipleCursorsAddDown<CR>",
			mode = { "n", "i" },
			desc = "MultipleCursorsAddDown",
		},
		{
			"<Leader>cj",
			"<Cmd>MultipleCursorsAddDown<CR>",
			desc = "MultipleCursorsAddDown",
		},
		{
			"<C-Up>",
			"<Cmd>MultipleCursorsAddUp<CR>",
			mode = { "n", "i" },
			desc = "MultipleCursorsAddUp",
		},
		{
			"<Leader>ck",
			"<Cmd>MultipleCursorsAddUp<CR>",
			desc = "MultipleCursorsAddUp",
		},
		{
			"<Leader>ac",
			"<Cmd>MultipleCursorsAddMatches<CR>",
			mode = { "n", "x" },
			desc = "MultipleCursorsAddMatches",
		},
		{
			"<Leader>AC",
			"<Cmd>MultipleCursorsAddMatchesV<CR>", -- V variant: matches in visible viewport only
			mode = { "n", "x" },
			desc = "MultipleCursorsAddMatchesV",
		},
		{
			"<Leader>cn",
			"<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
			mode = { "n", "x" },
			desc = "MultipleCursorsAddJumpNextMatch",
		},
		{
			"<Leader>CN",
			"<Cmd>MultipleCursorsJumpNextMatch<CR>", -- jump to next match without placing a cursor
			desc = "MultipleCursorsAddJumpNextMatch",
		},
		{
			"<Leader>lc",
			"<Cmd>MultipleCursorsLock<CR>",
			mode = { "n", "x" },
			desc = "MultipleCursorsLock",
		},
	},
}
