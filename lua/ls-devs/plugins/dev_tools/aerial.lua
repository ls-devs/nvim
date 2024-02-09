return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>at", "<cmd>AerialToggle<CR>", desc = "Aerial Toggle", noremap = true, silent = true },
		{ "<leader>an", "<cmd>AerialNext<CR>", desc = "Aerial Next", noremap = true, silent = true },
		{ "<leader>ap", "<cmd>AerialPrev<CR>", desc = "Aerial Prev", noremap = true, silent = true },
		{
			"<leader>ta",
			"<cmd>Telescope aerial<CR>",
			desc = "Telescope aerial",
			noremap = true,
			silent = true,
		},
	},
	opts = {
		backends = { "treesitter", "lsp", "markdown", "man" },
		layout = {
			max_width = { 40, 0.2 },
			width = nil,
			min_width = 25,
			win_opts = {},
			default_direction = "left",
			placement = "window",
			preserve_equality = false,
		},
		attach_mode = "window",
		close_automatic_events = {},
		lazy_load = true,
		disable_max_lines = 10000,
		disable_max_size = 2000000, -- Default 2MB
		highlight_mode = "split_width",
		highlight_closest = true,
		highlight_on_hover = false,
		highlight_on_jump = 300,
		autojump = false,
		icons = {},
		ignore = {
			unlisted_buffers = false,
			filetypes = {},
			buftypes = "special",
			wintypes = "special",
		},
		manage_folds = true,
		link_folds_to_tree = true,
		link_tree_to_folds = true,
		nerd_font = "auto",
		open_automatic = false,
		post_jump_cmd = "normal! zz",
		close_on_select = false,
		update_events = "TextChanged,InsertLeave",
		show_guides = true,
		guides = {
			mid_item = "├─",
			last_item = "└─",
			nested_top = "│ ",
			whitespace = "  ",
		},
		float = {
			border = "rounded",
			relative = "cursor",
			max_height = 0.9,
			height = nil,
			min_height = { 8, 0.1 },
		},
		nav = {
			border = "rounded",
			max_height = 0.9,
			min_height = { 10, 0.1 },
			max_width = 0.5,
			min_width = { 0.2, 20 },
			win_opts = {
				cursorline = true,
				winblend = 10,
			},
			autojump = false,
			preview = false,
		},
		lsp = {
			diagnostics_trigger_update = true,
			update_when_errors = true,
			update_delay = 300,
			priority = {},
		},
		treesitter = {
			update_delay = 300,
		},
		markdown = {
			update_delay = 300,
		},
		man = {
			update_delay = 300,
		},
	},
	config = function(_, opts)
		require("aerial").setup(opts)
		require("telescope").load_extension("aerial")
	end,
}