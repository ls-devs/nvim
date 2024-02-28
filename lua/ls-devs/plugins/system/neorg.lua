return {
	"nvim-neorg/neorg",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = {
		"BufReadPre " .. vim.env.NOTESDIR .. "/**.md",
		"BufNewFile " .. vim.env.NOTESDIR .. "/**.md",
	},
	build = ":Neorg sync-parsers",
	cmd = "Neorg",
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.ui"] = {},
				["core.export"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							Personal = vim.env.NOTESDIR .. "/Personal",
							Work = vim.env.NOTESDIR .. "/Work",
						},
						default_workspace = "Personal",
					},
				},
				["core.integrations.nvim-cmp"] = {},
				["core.integrations.treesitter"] = {},
				["core.syntax"] = {},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
						name = "neorg",
					},
				},
				["core.pivot"] = {},
				["core.promo"] = {},
				["core.qol.toc"] = {},
				["core.qol.todo_items"] = {},
				["core.ui.calendar"] = {},
				["core.summary"] = {},
			},
		})
	end,
}
