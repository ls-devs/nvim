-- ── mini.comment ──────────────────────────────────────────────────────────
-- Purpose : Context-aware code commenter using `gc` operator
-- Trigger : keys — gc (normal + visual)
-- Note    : ts_context_commentstring is called manually via custom_commentstring;
--           enable_autocmd=false prevents double-invocation
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"echasnovski/mini.comment",
	config = function()
		local comment = require("mini.comment")
		comment.setup({
			options = {
				-- Delegate comment-string resolution to Treesitter context
				-- so embedded languages (e.g. JSX inside TSX) get the right syntax
				---@return string
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})
	end,
	keys = {
		{
			"gc",
			mode = { "n", "v" },
			desc = "Comment",
			silent = true,
			noremap = true,
		},
	},
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			lazy = true,
			opts = {
				-- mini.comment calls calculate_commentstring() directly, so the
				-- autocmd-based hook from ts_context_commentstring is not needed
				enable_autocmd = false,
			},
		},
	},
}
