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
			"<Cmd>MultipleCursorsAddMatchesV<CR>",
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
			"<Cmd>MultipleCursorsJumpNextMatch<CR>",
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
