return {
	"ggandor/flit.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		keys = { f = "f", F = "F", t = "t", T = "T" },
		labeled_modes = "nvo",
		multiline = true,
	},
	dependencies = {
		{ "ggandor/leap.nvim", lazy = true },
		{ "tpope/vim-repeat", lazy = true },
		{
			"ggandor/leap-spooky.nvim",
			lazy = true,
			opts = {
				affixes = {
					remote = { window = "r", cross_window = "R" },
					magnetic = { window = "m", cross_window = "M" },
				},
				paste_on_remote_yank = false,
			},
		},
	},
}
