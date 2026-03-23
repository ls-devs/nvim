-- ── gitsigns.nvim ─────────────────────────────────────────────────────────
-- Purpose : Git decorations in the sign column + inline EOL blame
-- Trigger : event = { "BufReadPost", "BufNewFile" }
-- ──────────────────────────────────────────────────────────────────────────
---@type LazySpec
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
			virt_text_pos = "eol",
			delay = 1000,
			ignore_whitespace = false,
			-- priority=300 keeps blame rightmost — drawn last per Neovim's
			-- virt_text rule (highest priority = drawn last = rightmost).
			-- order: search(10) → neotest(100) → blame(300)
			virt_text_priority = 300,
			use_focus = true,
		},
		current_line_blame_formatter = "   <author> • <author_time:%d/%m/%Y> • <summary> ", -- virtual text: nerd-font icon · author · date · summary
		-- Priority 1 ensures diagnostic signs always win over git signs
		-- in the sign column when both appear on the same line.
		sign_priority = 1,
		update_debounce = 100,
		max_file_length = 40000, -- skip sign attachment on files larger than ~40k lines
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	},
	---@return boolean
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
}
