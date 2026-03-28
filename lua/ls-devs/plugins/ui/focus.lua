-- ── focus.nvim ────────────────────────────────────────────────────────────
-- Purpose : Auto-resize the focused window using golden-ratio proportions
-- Trigger : BufReadPost, BufNewFile
-- Note    : autoresize enabled by default; per-filetype suppression (neo-tree,
--           DAP panels, OverseerList, etc.) is managed by autocmds in core/autocmds.lua
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
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
		-- Enabled by default; toggle with <leader>wr
		autoresize = {
			enable = true,
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
	config = function(_, opts)
		require("focus").setup(opts)
		-- Start with autoresize disabled so window-switching doesn't resize unexpectedly.
		-- Use <leader>wr (FocusToggle) to enable golden-ratio autoresize on demand.
		-- Must be set AFTER setup() so the WinEnter autocmd is still registered
		-- (autocmd.setup early-exits if focus_disable is already true at setup time).
		vim.g.focus_disable = true
	end,
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
			"<cmd>FocusToggle<CR>",
			desc = "Focus Toggle Autoresize",
			silent = true,
			noremap = true,
		},
	},
}
