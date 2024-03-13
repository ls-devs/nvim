return {
	"sustech-data/wildfire.nvim",
	keys = {
		"<C-Space>",
	},
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		surrounds = {
			{ "(", ")" },
			{ "{", "}" },
			{ "<", ">" },
			{ "[", "]" },
		},
		keymaps = {
			init_selection = "<C-Space>",
			node_incremental = "<C-Space>",
			node_decremental = "<BS>",
		},
		filetype_exclude = { "qf" }, --keymaps will be unset in excluding filetypes
	},
}
