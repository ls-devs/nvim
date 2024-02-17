return {
	"kevinhwang91/nvim-bqf",
	ft = "qf",
	dependencies = {
		"junegunn/fzf",
		lazy = true,
		build = function()
			vim.fn["fzf#install"]()
		end,
	},
	opts = {
		auto_enable = true,
		auto_resize_height = true,
		func_map = {
			open = "<cr>",
			openc = "o",
			vsplit = "v",
			split = "s",
			fzffilter = "f",
			pscrollup = "<C-u>",
			pscrolldown = "<C-d>",
			ptogglemode = "F",
			filter = "n",
			filterr = "N",
		},
		preview = {
			winblend = 0,
		},
	},
}
