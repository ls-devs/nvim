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
			"rasulomaroff/telepath.nvim",
			lazy = true,
			config = function()
				require("telepath").use_default_mappings({ overwrite = true })
			end,
		},
	},
}
