-- ── nvim-treesitter-context ──────────────────────────────────────────────
-- Purpose : Sticky context header — pins the enclosing function/class/block
--           signature at the top of the window so it stays visible while
--           scrolling through deeply nested code.
-- Trigger : BufReadPost / BufNewFile
-- Note    : The separator line uses a light-horizontal box-drawing char to
--           visually separate context from code (distinct from fillchars ━).
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		enable = true,
		max_lines = 4, -- cap context height at 4 lines
		min_window_height = 15, -- don't render in tiny windows
		line_numbers = true,
		multiline_threshold = 10, -- max lines per context node before truncating
		trim_scope = "outer", -- drop outermost context when max_lines is exceeded
		mode = "cursor", -- context tracks the cursor position
		separator = "─", -- thin divider below context (U+2500)
		zindex = 20,
		on_attach = nil,
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("treesitter-context").setup(opts)

		-- When a floating window closes (notifications, hover, etc.) Neovim
		-- does not always repaint the context header area until the next real
		-- cursor event. Fire CursorMoved synthetically so treesitter-context's
		-- own au_update path re-renders the header immediately.
		vim.api.nvim_create_autocmd("WinClosed", {
			group = vim.api.nvim_create_augroup("ts_context_win_refresh", { clear = true }),
			callback = vim.schedule_wrap(function()
				vim.api.nvim_exec_autocmds("CursorMoved", { buffer = 0, modeline = false })
			end),
		})
	end,
	keys = {
		{
			"[x",
			function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end,
			desc = "Jump to Context",
			noremap = true,
			silent = true,
		},
	},
}
