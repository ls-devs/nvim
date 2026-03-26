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
		-- Block attachment to floating windows and special buffers.
		-- Hover docs, notifications, and nofile buffers can carry injected
		-- language trees (e.g. vim-lang inside markdown code fences) that
		-- trigger a broken vim query in Neovim 0.12-dev causing errors.
		on_attach = function(buf)
			if vim.bo[buf].buftype ~= "" then
				return false
			end
			for _, win in ipairs(vim.fn.win_findbuf(buf)) do
				if vim.api.nvim_win_get_config(win).relative ~= "" then
					return false
				end
			end
			return true
		end,
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("treesitter-context").setup(opts)
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
