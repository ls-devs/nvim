-- ── smart-splits.nvim ────────────────────────────────────────────────────
-- Purpose : Seamless split/pane navigation and resizing between Neovim and
--           terminal multiplexers (tmux, kitty, wezterm, etc.)
-- Trigger : keys — loads only when a split navigation key is pressed
-- Keymaps :
--   <C-h/j/k/l>        move focus between splits
--   <M-h/j/k/l>        resize splits
--   <leader><C-h/j/k/l> swap buffers between splits
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"mrjones2014/smart-splits.nvim",
	keys = {
		-- ── Move between splits ───────────────────────────────────────────
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
			desc = "Move to left split",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			desc = "Move to below split",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			desc = "Move to above split",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			desc = "Move to right split",
		},
		-- ── Resize splits ─────────────────────────────────────────────────
		{
			"<M-h>",
			function()
				require("smart-splits").resize_left()
			end,
			desc = "Resize split left",
		},
		{
			"<M-j>",
			function()
				require("smart-splits").resize_down()
			end,
			desc = "Resize split down",
		},
		{
			"<M-k>",
			function()
				require("smart-splits").resize_up()
			end,
			desc = "Resize split up",
		},
		{
			"<M-l>",
			function()
				require("smart-splits").resize_right()
			end,
			desc = "Resize split right",
		},
		-- ── Swap buffers between splits ───────────────────────────────────
		{
			"<leader><C-h>",
			function()
				require("smart-splits").swap_buf_left()
			end,
			desc = "Swap buffer left",
		},
		{
			"<leader><C-j>",
			function()
				require("smart-splits").swap_buf_down()
			end,
			desc = "Swap buffer down",
		},
		{
			"<leader><C-k>",
			function()
				require("smart-splits").swap_buf_up()
			end,
			desc = "Swap buffer up",
		},
		{
			"<leader><C-l>",
			function()
				require("smart-splits").swap_buf_right()
			end,
			desc = "Swap buffer right",
		},
	},
	opts = {
		resize_mode = {
			silent = true,
			hooks = {
				on_enter = function()
					vim.notify("Entering resize mode")
				end,
				on_leave = function()
					vim.notify("Exiting resize mode, bye")
				end,
			},
		},
	},
}
