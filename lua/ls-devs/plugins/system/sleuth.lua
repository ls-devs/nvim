-- ── vim-sleuth ────────────────────────────────────────────────────────────
-- Purpose : Auto-detects and sets indentation (shiftwidth, tabstop, expandtab)
-- Trigger : BufReadPre, BufNewFile
-- ─────────────────────────────────────────────────────────────────────────
return {
	"tpope/vim-sleuth",
	event = { "BufReadPre", "BufNewFile" },
}
