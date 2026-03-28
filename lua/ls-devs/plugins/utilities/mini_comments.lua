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
				-- Skip blank lines when toggling a comment range (gcip won't comment empty lines)
				ignore_blank_line = true,
				-- Delegate comment-string resolution to Treesitter context
				-- so embedded languages (e.g. JSX inside TSX) get the right syntax.
				-- ref_position is forwarded so multi-line ranges use the start position,
				-- not the cursor position (fixes wrong commentstring on JSX/TSX blocks).
				---@param ref_position {[1]: integer, [2]: integer}
				---@return string
				custom_commentstring = function(ref_position)
					return require("ts_context_commentstring.internal").calculate_commentstring({
						key = "__default",
						location = { ref_position[1] - 1, ref_position[2] },
					}) or vim.bo.commentstring
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
