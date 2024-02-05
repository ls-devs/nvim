return {
	"sindrets/diffview.nvim",
	keys = {
		{
			"<leader>dvo",
			require("ls-devs.utils.custom_functions").DiffviewToggle,
			desc = "DiffviewOpen",
			noremap = true,
			silent = true,
		},
	},
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
}
