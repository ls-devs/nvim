return {
	"cbochs/grapple.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	opts = {
		scope = "git",
	},
	cmd = "Grapple",
	keys = {
		{ "<leader>ha", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
		{ "<leader>ht", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },
		{ "<leader>hs", "<cmd>Grapple toggle_scopes<cr>", desc = "Grapple toggle scopes" },
	},
}
