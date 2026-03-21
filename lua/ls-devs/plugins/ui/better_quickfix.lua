-- ── nvim-bqf ──────────────────────────────────────────────────────────────
-- Purpose : Enhanced quickfix window with floating preview and fzf filtering
-- Trigger : ft = qf (loads when any quickfix window opens)
-- Note    : Requires junegunn/fzf for fuzzy filtering; preview skips files
--           larger than 100 KB and fugitive:// virtual buffers
-- ─────────────────────────────────────────────────────────────────────────
return {
	"kevinhwang91/nvim-bqf",
	ft = "qf",
	dependencies = {
		"junegunn/fzf",
		lazy = true,
	},
	opts = {
		auto_enable = true,
		-- Shrinks the quickfix window to fit its content instead of using a fixed height
		auto_resize_height = true,
		preview = {
			win_height = 12,
			win_vheight = 12,
			winblend = 0,
			-- Defer syntax highlighting in the preview to avoid flicker on fast navigation
			delay_syntax = 80,
			border = "rounded",
			show_title = true,
			-- Skip preview for large files (> 100 KB) and fugitive virtual buffers
			should_preview_cb = function(bufnr, qwinid)
				local ret = true
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				local fsize = vim.fn.getfsize(bufname)
				if fsize > 100 * 1024 then
					ret = false
				elseif bufname:match("^fugitive://") then
					ret = false
				end
				return ret
			end,
		},
		-- Remap quickfix navigation keys to more ergonomic bindings
		func_map = {
			drop = "o",
			openc = "O",
			split = "<C-s>",
			tabdrop = "<C-t>",
			tabc = "", -- disable default tab binding to avoid conflicts
			ptogglemode = "z,", -- toggle between full/minimal preview mode
		},
		filter = {
			fzf = {
				action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
				-- ctrl-o selects / deselects all fzf matches at once
				extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
			},
		},
	},
}
