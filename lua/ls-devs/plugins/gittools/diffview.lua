-- ── diffview.nvim ─────────────────────────────────────────────────────────
-- Purpose : Side-by-side diff viewer and file history browser
-- Trigger : cmd = "Diffview*"
-- Note    : File panel and history panel open as centered floats (100×24).
--           The view_opened hook auto-opens the panel and forces laststatus=3.
--           Toggle via DiffviewToggle in utils/custom_functions.lua.
-- ──────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"sindrets/diffview.nvim",

	opts = {
		diff_binaries = false,
		enhanced_diff_hl = true, -- richer diff highlights via treesitter/LSP tokens
		git_cmd = { "git" },
		hg_cmd = { "hg" },
		use_icons = true,
		show_help_hints = true,
		watch_index = true, -- auto-refresh diffs when the git index changes on disk
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
				layout = "diff3_mixed", -- base in centre, ours/theirs on either side
				disable_diagnostics = true, -- suppress LSP noise during a 3-way merge
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
				flatten_dirs = true, -- collapse single-child dirs into one node
				folder_statuses = "only_folded", -- show status icon only on collapsed dirs
			},
			-- Centered float, capped at 100 columns × 24 lines
			---@return table
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
						diff_merges = "combined", -- show all parents' diffs merged in one unified view
						follow = true, -- follow renames in single-file history
					},
					multi_file = {
						diff_merges = "first-parent", -- follow only the first-parent path for cleaner multi-file history
					},
				},
				hg = {
					single_file = {},
					multi_file = {},
				},
			},
			-- Centered float, capped at 100 columns × 24 lines
			---@return table
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
			-- Auto-open the file panel and restore global statusline on every diff view open
			view_opened = function()
				require("diffview.actions").toggle_files()
				vim.cmd("set laststatus=3") -- single statusline shared across all windows
			end,
		},
	},
	cmd = "Diffview",
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("diffview").setup(opts)
		require("diffview.ui.panel").Panel.default_config_float.border = "rounded" -- patch all floating panel borders to match the UI theme
	end,
	keys = {
		{
			"<leader>dvo",
			require("ls-devs.utils.custom_functions").DiffviewToggle,
			desc = "DiffviewOpen",
			noremap = true,
			silent = true,
		},
		{
			"<leader>dvf",
			"<cmd>DiffviewFileHistory %<CR>",
			desc = "Diffview File History",
			noremap = true,
			silent = true,
		},
		{
			"<leader>dvF",
			"<cmd>DiffviewFileHistory<CR>",
			desc = "Diffview Repo History",
			noremap = true,
			silent = true,
		},
	},
	---@return boolean
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
}
