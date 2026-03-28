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
			mode = { "n", "t" },
			desc = "Move to left split",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			mode = { "n", "t" },
			desc = "Move to below split",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			mode = { "n", "t" },
			desc = "Move to above split",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			mode = { "n", "t" },
			desc = "Move to right split",
		},
		-- ── Resize splits ─────────────────────────────────────────────────
		{
			"<M-h>",
			function()
				require("smart-splits").resize_left()
			end,
			mode = { "n", "t" },
			desc = "Resize split left",
		},
		{
			"<M-j>",
			function()
				-- Resize only when windows are stacked horizontally (different row positions).
				-- Pure side-by-side layouts have identical rows → fall through to move-line.
				local wins = vim.tbl_filter(function(w)
					return vim.api.nvim_win_get_config(w).relative == ""
				end, vim.api.nvim_tabpage_list_wins(0))
				local first_row = #wins > 0 and vim.api.nvim_win_get_position(wins[1])[1] or 0
				local has_hori = vim.iter(wins):any(function(w)
					return vim.api.nvim_win_get_position(w)[1] ~= first_row
				end)
				if has_hori then
					require("smart-splits").resize_down()
				elseif vim.api.nvim_get_mode().mode == "n" then
					local row = vim.api.nvim_win_get_cursor(0)[1]
					if row < vim.api.nvim_buf_line_count(0) then
						vim.cmd("m .+1")
						vim.cmd("normal! ==")
					end
				end
			end,
			mode = { "n", "t" },
			desc = "Resize split down / Move line down",
		},
		{
			"<M-k>",
			function()
				local wins = vim.tbl_filter(function(w)
					return vim.api.nvim_win_get_config(w).relative == ""
				end, vim.api.nvim_tabpage_list_wins(0))
				local first_row = #wins > 0 and vim.api.nvim_win_get_position(wins[1])[1] or 0
				local has_hori = vim.iter(wins):any(function(w)
					return vim.api.nvim_win_get_position(w)[1] ~= first_row
				end)
				if has_hori then
					require("smart-splits").resize_up()
				elseif vim.api.nvim_get_mode().mode == "n" then
					local row = vim.api.nvim_win_get_cursor(0)[1]
					if row > 1 then
						vim.cmd("m .-2")
						vim.cmd("normal! ==")
					end
				end
			end,
			mode = { "n", "t" },
			desc = "Resize split up / Move line up",
		},
		{
			"<M-l>",
			function()
				require("smart-splits").resize_right()
			end,
			mode = { "n", "t" },
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
		-- Prevent smart-splits from trying to navigate/resize into neo-tree
		ignored_filetypes = { "NvimTree", "neo-tree", "neo-tree-popup" },
		-- After a buffer swap, keep the cursor in the buffer it was editing
		cursor_follows_swapped_bufs = true,
		resize_mode = {
			silent = true,
			hooks = {
				on_enter = function()
					vim.notify("Entering resize mode")
				end,
				on_leave = function()
					vim.notify("Exiting resize mode")
				end,
			},
		},
	},
}
