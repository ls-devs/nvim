-- ── gitsigns.nvim ─────────────────────────────────────────────────────────
-- Purpose : Git decorations in the sign column + inline EOL blame
-- Trigger : event = { "BufReadPost", "BufNewFile" }
-- ──────────────────────────────────────────────────────────────────────────
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false, -- intra-line word-level diff; enable for finer change granularity
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false, -- skip buffers for files not yet tracked by git
		current_line_blame = true, -- show inline git blame at end of current line
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- blame appended after the last character on the line
			delay = 1000, -- ms delay before rendering blame to reduce flicker while typing
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true, -- only show blame when the window is focused
		},
		current_line_blame_formatter = "   <author> • <author_time:%d/%m/%Y> • <summary> ", -- virtual text: nerd-font icon · author · date · summary
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil,
		max_file_length = 40000, -- skip sign attachment on files larger than ~40k lines
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	},
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
}
