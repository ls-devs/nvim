-- ── focus.nvim ────────────────────────────────────────────────────────────
-- Purpose : Manual window resizing — golden-ratio maximise or equalise on demand
-- Trigger : BufReadPost, BufNewFile
-- Note    : autoresize (auto-resize on WinEnter) is intentionally disabled.
--           Use <leader>wm to maximise the current window and <leader>we to
--           restore equal splits. No resize fires automatically on Ctrl-H/L.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-focus/focus.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		enable = true,
		commands = true,
		split = {
			bufnew = false,
			tmux = false,
		},
		-- Disable auto-resize on WinEnter: prevents the WinEnter autocmd from
		-- being created entirely. Without this, even "toggled off" state still
		-- runs split_resizer on every window switch and modifies winwidth/winheight.
		autoresize = {
			enable = false,
		},
		-- All visual changes disabled; focus.nvim is used purely for manual resizing
		ui = {
			number = false,
			relativenumber = false,
			hybridnumber = false,
			absolutenumber_unfocussed = false,
			cursorline = false,
			cursorcolumn = false,
			colorcolumn = { enable = false },
			signcolumn = false,
			winhighlight = false,
		},
	},
	keys = {
		{
			"<leader>wm",
			"<cmd>FocusMaximise<CR>",
			desc = "Focus Maximise Window",
			silent = true,
			noremap = true,
		},
		{
			"<leader>we",
			"<cmd>FocusEqualise<CR>",
			desc = "Focus Equalize Window",
			silent = true,
			noremap = true,
		},
		{
			"<leader>wr",
			"<cmd>FocusMaxOrEqual<CR>",
			desc = "Focus Max or Equalise",
			silent = true,
			noremap = true,
		},
	},
}
