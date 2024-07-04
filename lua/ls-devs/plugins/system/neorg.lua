return {
	"nvim-neorg/neorg",
	event = {
		"BufReadPre " .. vim.env.NOTESDIR .. "/**.md",
		"BufNewFile " .. vim.env.NOTESDIR .. "/**.md",
	},
	cmd = "Neorg",
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
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							Notes = vim.env.NOTESDIR .. "/",
						},
						default_workspace = "Notes",
					},
				},
				["core.export"] = {},
				["core.export.markdown"] = {},
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
			opts = {
				window = {
					backdrop = 0.95,
					width = 120,
					height = 1,
					options = {
						signcolumn = "no",
						number = false,
						relativenumber = false,
						cursorline = false,
						cursorcolumn = false,
						foldcolumn = "0",
						list = false,
						laststatus = 0,
					},
				},
				plugins = {
					options = {
						enabled = false,
						ruler = false,
						showcmd = false,
						laststatus = 0,
					},
					twilight = { enabled = false },
					gitsigns = { enabled = false },
					tmux = { enabled = false },
				},
			},
		},
		{ "plenary.nvim", lazy = true },
		{ "luarocks.nvim", lazy = true },
		{
			"jmbuhr/otter.nvim",
			opts = {
				lsp = {
					diagnostic_update_events = { "BufWritePost" },
					root_dir = function(_, bufnr)
						return vim.fs.root(bufnr or 0, {
							".git",
							"_quarto.yml",
							"package.json",
						}) or vim.fn.getcwd(0)
					end,
				},
				buffers = {
					set_filetype = false,
					write_to_disk = false,
				},
				strip_wrapping_quote_characters = { "'", '"', "`" },
				handle_leading_whitespace = false,
			},
		},
		{ "nvim-treesitter/nvim-treesitter", lazy = true },
	},
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
			":Neorg workspace Notes<CR>",
			desc = "Select Neorg Workspace",
			silent = true,
			noremap = true,
		},
	},
}
