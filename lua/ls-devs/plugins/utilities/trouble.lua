return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		auto_close = true,
		auto_fold = true,
		auto_preview = false,
		use_diagnostic_signs = true,
		action_keys = {
			toggle_fold = { "zA", "za", "l" }, -- toggle fold of current filetoggle_fold = {"zA", "za"}, -- toggle fold of current file
		},
	},
	keys = {
		{
			"<leader>v",
			"<cmd>Trouble<CR>",
			desc = "Trouble",
			silent = true,
			noremap = true,
		},
	},
}
