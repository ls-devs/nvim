return {
	{
		"nvim-neorg/neorg",
		dependencies = { "nvim-lua/plenary.nvim", "folke/zen-mode.nvim" },
		event = {
			"BufReadPre " .. vim.env.NOTESDIR .. "/**.md",
			"BufNewFile " .. vim.env.NOTESDIR .. "/**.md",
		},
		build = ":Neorg sync-parsers",
		cmd = "Neorg",
		keys = {
			{
				"<leader>nt",
				":Neorg<CR>",
				desc = "Open Neorg",
				silent = true,
				noremap = true,
			},
			{
				"<leader>nw",
				function()
					vim.ui.select({ "Personal", "Work" }, {
						prompt = "Choose a Workspace",
					}, function(choice)
						if choice then
							vim.cmd("Neorg workspace " .. choice)
						end
					end)
				end,
				desc = "Select Neorg Workspace",
				silent = true,
				noremap = true,
			},
		},
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.ui"] = {},
					["core.export"] = {},
					["core.export.markdown"] = {},
					["core.highlights"] = {},
					["core.mode"] = {},
					["core.queries.native"] = {},
					["core.presenter"] = {
						config = {
							zen_mode = "zen-mode",
						},
					},
					["core.manoeuvre"] = {},
					["core.storage"] = {},
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
					["core.autocommands"] = {},
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
							name = "neorg",
						},
					},
					["core.ui.calendar"] = {},
					["core.summary"] = {},
				},
			})
		end,
	},
}
