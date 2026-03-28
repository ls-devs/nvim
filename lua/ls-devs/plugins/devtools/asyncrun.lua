-- ── asyncrun.vim ──────────────────────────────────────────────────────────
-- Purpose : Run shell commands asynchronously without blocking the editor
-- Trigger : cmd = AsyncRun
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"skywind3000/asyncrun.vim",
	cmd = { "AsyncRun", "AsyncStop", "AsyncReset" },
	init = function()
		vim.g.asyncrun_open = 8 -- auto-open quickfix window with 8-line height
		vim.g.asyncrun_bell = 1 -- ring bell on completion
		vim.g.asyncrun_save = 1 -- save current buffer before running
		vim.g.asyncrun_trim = 1 -- trim trailing blank lines from output
	end,
}
