-- ── asyncrun.vim ──────────────────────────────────────────────────────────
-- Purpose : Run shell commands asynchronously without blocking the editor
-- Trigger : cmd = AsyncRun
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"skywind3000/asyncrun.vim",
	cmd = { "AsyncRun", "AsyncStop", "AsyncReset" },
}
