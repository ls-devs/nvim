-- ── focus.nvim ────────────────────────────────────────────────────────────
-- Purpose : Auto-resize the focused window using golden-ratio proportions
-- Trigger : BufReadPost, BufNewFile
-- Note    : autoresize starts disabled; per-filetype suppression (neo-tree,
--           DAP panels, OverseerList, etc.) is managed by autocmds in legendary.lua
-- ─────────────────────────────────────────────────────────────────────────
return {
	"nvim-focus/focus.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		enable = true,
		commands = true,
		split = {
			-- Don't auto-resize when a blank new buffer opens inside a split
			bufnew = false,
			-- Don't propagate focus sizing to tmux panes
			tmux = false,
		},
		-- Off by default; toggled with <leader>wr or suppressed per-filetype via legendary.lua
		autoresize = {
			enable = false,
		},
		-- All visual changes disabled; focus.nvim is used purely for window resizing
		ui = {
			number = false,
			relativenumber = false,
			hybridnumber = false,
			absolutenumber_unfocussed = false,

			cursorline = false,
			cursorcolumn = false,
			colorcolumn = {
				enable = false,
			},
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
			"<cmd>FocusAutoresize<CR>",
			desc = "Focus Autoresize Window",
			silent = true,
			noremap = true,
		},
	},
}
