-- ── gitsigns.nvim ─────────────────────────────────────────────────────────
-- Purpose : Git decorations in the sign column + inline EOL blame
-- Trigger : event = { "BufReadPost", "BufNewFile" }
-- Keymaps : <leader>gws  stage hunk   <leader>gwu  reset (unstage) hunk
--           <leader>gwp  preview hunk  <leader>gwB  full blame popup
--           <leader>gwb  toggle blame  <leader>gwd  toggle word diff
--           ih / ah     hunk text object (o/x mode)
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
		word_diff = false,
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false, -- skip buffers for files not yet tracked by git
		current_line_blame = true, -- show inline git blame at end of current line
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			delay = 500,
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
	keys = {
		{
			"<leader>gwb",
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			desc = "Gitsigns Toggle Blame",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gwd",
			function()
				require("gitsigns").toggle_word_diff()
			end,
			desc = "Gitsigns Toggle Word Diff",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gws",
			function()
				require("gitsigns").stage_hunk()
			end,
			desc = "Gitsigns Stage Hunk",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gwu",
			function()
				require("gitsigns").reset_hunk()
			end,
			desc = "Gitsigns Reset Hunk",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gwp",
			function()
				require("gitsigns").preview_hunk()
			end,
			desc = "Gitsigns Preview Hunk",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gwB",
			function()
				require("gitsigns").blame_line({ full = true })
			end,
			desc = "Gitsigns Blame Full",
			noremap = true,
			silent = true,
		},
		-- Hunk text object: dih deletes a hunk, cih changes it, yih yanks it
		{ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Gitsigns Inner Hunk", silent = true },
		{ "ah", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Gitsigns Around Hunk", silent = true },
		-- Hunk navigation
		{
			"]h",
			function()
				require("gitsigns").next_hunk()
			end,
			desc = "Next Hunk",
			noremap = true,
			silent = true,
		},
		{
			"[h",
			function()
				require("gitsigns").prev_hunk()
			end,
			desc = "Prev Hunk",
			noremap = true,
			silent = true,
		},
	},
	---@return boolean
	cond = function()
		-- Search upward for .git dir (normal repo) or .git file (worktree)
		return vim.fn.finddir(".git", ".;") ~= "" or vim.fn.findfile(".git", ".;") ~= ""
	end,
}
