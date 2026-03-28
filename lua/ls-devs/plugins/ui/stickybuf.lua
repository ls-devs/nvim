-- ── stickybuf.nvim ───────────────────────────────────────────────────────────
-- Purpose : Pins special buffers (terminal, quickfix, help, etc.) to their
--           windows so they cannot be replaced by a normal buffer edit.
-- Trigger : BufReadPost
-- ─────────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"stevearc/stickybuf.nvim",
	event = "BufReadPost",
	opts = {
		---@param bufnr integer
		---@return string?
		get_auto_pin = function(bufnr)
			return require("stickybuf").should_auto_pin(bufnr)
		end,
	},
}
