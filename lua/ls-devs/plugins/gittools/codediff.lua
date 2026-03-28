-- ── codediff.nvim ─────────────────────────────────────────────────────────
-- Purpose : VSCode-style diff viewer, file history browser, and conflict resolver
-- Trigger : cmd = "CodeDiff"
-- Replaces: diffview.nvim, git-conflict.nvim, vim-fugitive
--
-- Keymaps (global):
--   <leader>gd    Open explorer (staged / unstaged / conflicts)
--   <leader>gf    File history (current buffer)
--   <leader>gF    Repo-wide history
--
-- Keymaps (inside codediff view):
--   q             Close diff tab
--   ]c / [c       Next / prev change hunk
--   ]f / [f       Next / prev file (explorer/history mode)
--   t             Toggle side-by-side ↔ inline layout
--   g?            Show keymaps help
--   Conflict view:
--     <leader>gco   Accept current (ours)
--     <leader>gct   Accept incoming (theirs)
--     <leader>gcb   Accept both
--     <leader>gcn   Discard both (keep base)
--     <leader>gcO   Accept ALL current in file
--     <leader>gcT   Accept ALL incoming in file
--     <leader>gcB   Accept ALL both in file
--     <leader>gcN   Discard ALL in file
--     ]x / [x       Next / prev conflict
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	---@return boolean
	cond = function()
		-- isdirectory() misses two common cases: (1) Neovim opened from a repo
		-- subdirectory where .git is in a parent; (2) git worktrees where .git
		-- is a file, not a directory. Search upward for both forms.
		return vim.fn.finddir(".git", ".;") ~= "" or vim.fn.findfile(".git", ".;") ~= ""
	end,
	opts = {
		highlights = {
			line_insert = "DiffAdd",
			line_delete = "DiffDelete",
			char_insert = nil, -- auto-derived from line highlights
			char_delete = nil,
			char_brightness = nil, -- auto-detect: 1.4 dark / 0.92 light
			conflict_sign = nil,
			conflict_sign_resolved = nil,
			conflict_sign_accepted = nil,
			conflict_sign_rejected = nil,
		},
		diff = {
			layout = "side-by-side",
			disable_inlay_hints = true,
			max_computation_time_ms = 5000,
			ignore_trim_whitespace = false,
			hide_merge_artifacts = false,
			original_position = "left",
			conflict_ours_position = "right",
			conflict_result_position = "bottom",
			conflict_result_height = 30,
			cycle_next_hunk = true,
			cycle_next_file = true,
			jump_to_first_change = true,
			highlight_priority = 100,
			compute_moves = false,
		},
		explorer = {
			position = "left",
			width = 30,
			height = 15,
			indent_markers = true,
			initial_focus = "explorer",
			icons = {
				folder_closed = "",
				folder_open = "",
			},
			view_mode = "tree",
			flatten_dirs = true,
			file_filter = {
				ignore = { ".git/**", ".jj/**" },
			},
			focus_on_select = false,
			visible_groups = {
				staged = true,
				unstaged = true,
				conflicts = true,
			},
		},
		history = {
			position = "bottom",
			width = 30,
			height = 15,
			initial_focus = "history",
			view_mode = "list",
		},
		keymaps = {
			view = {
				quit = "q",
				toggle_explorer = "<leader>b",
				focus_explorer = "<leader>e",
				next_hunk = "]c",
				prev_hunk = "[c",
				next_file = "]f",
				prev_file = "[f",
				diff_get = "do",
				diff_put = "dp",
				open_in_prev_tab = "gf",
				close_on_open_in_prev_tab = false,
				toggle_stage = "-",
				stage_hunk = "<leader>hs",
				unstage_hunk = "<leader>hu",
				discard_hunk = "<leader>hr",
				hunk_textobject = "ih",
				show_help = "g?",
				align_move = "gm",
				toggle_layout = "t",
			},
			explorer = {
				select = "<CR>",
				hover = "K",
				refresh = "R",
				toggle_view_mode = "i",
				stage_all = "S",
				unstage_all = "U",
				restore = "X",
				toggle_changes = "gu",
				toggle_staged = "gs",
				fold_open = "zo",
				fold_open_recursive = "zO",
				fold_close = "zc",
				fold_close_recursive = "zC",
				fold_toggle = "za",
				fold_toggle_recursive = "zA",
				fold_open_all = "zR",
				fold_close_all = "zM",
			},
			history = {
				select = "<CR>",
				toggle_view_mode = "i",
				refresh = "R",
				fold_open = "zo",
				fold_open_recursive = "zO",
				fold_close = "zc",
				fold_close_recursive = "zC",
				fold_toggle = "za",
				fold_toggle_recursive = "zA",
				fold_open_all = "zR",
				fold_close_all = "zM",
			},
			-- Mirror the former git-conflict.nvim keymap prefixes (<leader>gc*)
			conflict = {
				accept_current = "<leader>gco", -- ours
				accept_incoming = "<leader>gct", -- theirs
				accept_both = "<leader>gcb",
				discard = "<leader>gcn", -- was GitConflictChooseNone
				accept_all_current = "<leader>gcO",
				accept_all_incoming = "<leader>gcT",
				accept_all_both = "<leader>gcB",
				discard_all = "<leader>gcN",
				next_conflict = "]x", -- same as former git-conflict.nvim
				prev_conflict = "[x",
				diffget_incoming = "2do",
				diffget_current = "3do",
			},
		},
	},
	keys = {
		{
			"<leader>gd",
			"<cmd>CodeDiff<CR>",
			desc = "CodeDiff Explorer",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gf",
			"<cmd>CodeDiff history %<CR>",
			desc = "CodeDiff File History",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gF",
			"<cmd>CodeDiff history<CR>",
			desc = "CodeDiff Repo History",
			noremap = true,
			silent = true,
		},
	},
}
