-- ── plenary ───────────────────────────────────────────────────────────────
-- Purpose : Shared Lua utility library (async, Path, Job, etc.)
-- Trigger : lazy — loaded on demand as a dependency
-- ─────────────────────────────────────────────────────────────────────────

-- Package required for :
-- Neo Tree
-- Git-Worktree
-- Todo Comments
-- Typescript Tools
-- Gx.nvim

---@type LazySpec
return {
	"nvim-lua/plenary.nvim",
	lazy = true,
}
