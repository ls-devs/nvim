-- ── vim-sleuth ────────────────────────────────────────────────────────────
-- Purpose : Auto-detects and sets indentation (shiftwidth, tabstop, expandtab)
-- Trigger : BufReadPre, BufNewFile
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"tpope/vim-sleuth",
	event = { "BufReadPre", "BufNewFile" },
}
