return {
	{
		"nvim-neorg/neorg",
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
					vim.ui.select({ "Notes", "Personal", "Work" }, {
						prompt = "Choose a Workspace",
					}, function(choice)
						if choice then
							if choice == "Notes" then
								vim.cmd("Neorg workspace " .. choice)
								vim.cmd("cd " .. vim.env.NOTESDIR)
							else
								vim.cmd("Neorg workspace " .. choice)
								vim.cmd("cd " .. vim.env.NOTESDIR .. "/" .. choice)
							end
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
					["core.completion"] = {
						config = {
							engine = "nvim-cmp",
							name = "neorg",
						},
					},
					["core.concealer"] = {
						config = {
							icons = {
								code_block = {
									conceal = true,
								},
							},
						},
					},
					["core.dirman"] = {
						config = {
							workspaces = {
								Notes = vim.env.NOTESDIR .. "/",
								Personal = vim.env.NOTESDIR .. "/Personal",
								Work = vim.env.NOTESDIR .. "/Work",
							},
							default_workspace = "Notes",
						},
					},
					["core.export"] = {},
					["core.export.markdown"] = {},
					["core.manoeuvre"] = {},
					["core.presenter"] = {
						config = {
							zen_mode = "zen-mode",
						},
					},
					["core.summary"] = {},
					["core.ui.calendar"] = {},
				},
			})
		end,
		dependencies = {
			{
				"folke/zen-mode.nvim",
				lazy = true,
				opts = {},
			},
			{ "nvim-lua/plenary.nvim" },
		},
	},
}
