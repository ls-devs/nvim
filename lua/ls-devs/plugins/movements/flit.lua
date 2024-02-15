return {
	"ggandor/flit.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		keys = { f = "f", F = "F", t = "t", T = "T" },
		labeled_modes = "nvo",
		multiline = true,
		opts = {},
	},
	dependencies = {
		{ "ggandor/leap.nvim" },
		{ "tpope/vim-repeat" },
		{
			"ggandor/leap-spooky.nvim",
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
