return {
	"sindrets/diffview.nvim",
	dependencies = { "plenary.nvim", lazy = true },
	opts = {
		diff_binaries = false,
		enhanced_diff_hl = true,
		git_cmd = { "git" },
		hg_cmd = { "hg" },
		use_icons = true,
		show_help_hints = true,
		watch_index = true,
		icons = {
			folder_closed = "",
			folder_open = "",
		},
		signs = {
			fold_closed = "",
			fold_open = "",
			done = "✓",
		},
		view = {
			default = {
				layout = "diff2_horizontal",
				winbar_info = false,
			},
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = true,
				winbar_info = false,
			},
			file_history = {
				layout = "diff2_horizontal",
				winbar_info = false,
			},
		},
		file_panel = {
			listing_style = "tree",
			tree_options = {
				flatten_dirs = true,
				folder_statuses = "only_folded",
			},
			win_config = function()
				local c = { type = "float", border = "rounded" }
				local editor_width = vim.o.columns
				local editor_height = vim.o.lines
				c.width = math.min(100, editor_width)
				c.height = math.min(24, editor_height)
				c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
				c.row = math.floor(editor_height * 0.5 - c.height * 0.5)
				return c
			end,
		},
		file_history_panel = {
			log_options = {
				git = {
					single_file = {
						diff_merges = "combined",
					},
					multi_file = {
						diff_merges = "first-parent",
					},
				},
				hg = {
					single_file = {},
					multi_file = {},
				},
			},
			win_config = function()
				local c = { type = "float", border = "rounded" }
				local editor_width = vim.o.columns
				local editor_height = vim.o.lines
				c.width = math.min(100, editor_width)
				c.height = math.min(24, editor_height)
				c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
				c.row = math.floor(editor_height * 0.5 - c.height * 0.5)
				return c
			end,
		},
		hooks = {
			view_opened = function()
				require("diffview.actions").toggle_files()
				vim.cmd("set laststatus=3")
			end,
		},
	},
	cmd = "Diffview",
	config = function(_, opts)
		require("diffview").setup(opts)
		require("diffview.ui.panel").Panel.default_config_float.border = "rounded"
	end,
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
