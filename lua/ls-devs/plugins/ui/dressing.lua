-- ── dressing.nvim ─────────────────────────────────────────────────────────
-- Purpose : Replaces vim.ui.input() and vim.ui.select() with styled floating windows
-- Trigger : VeryLazy
-- Note    : Any plugin calling vim.ui.input / vim.ui.select (rename, code
--           actions, etc.) automatically uses the dressing UI
-- ─────────────────────────────────────────────────────────────────────────
return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			title_pos = "center",
			enabled = true,
			start_in_insert = true,
			-- Allow normal-mode keymaps (e.g. <Esc> to close) inside the input box
			insert_only = false,
			-- Center the floating input on the editor rather than at the cursor position
			relative = "editor",
			mappings = {
				n = {
					["<Esc>"] = "Close",
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
				},
				i = {
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
					["<Up>"] = "HistoryPrev", -- cycle through previous inputs
					["<Down>"] = "HistoryNext", -- cycle through next inputs
				},
			},
		},
		nui = {
			relative = "editor",
		},
		select = {
			enabled = true,
		},
		builtin = {
			relative = "editor",
		},
	},
}
