-- ── scrollEOF.nvim ────────────────────────────────────────────────────────
-- Purpose : Allow scrolling past the end of the file while respecting scrolloff
-- Trigger : event — BufReadPost, BufNewFile
-- ─────────────────────────────────────────────────────────────────────────
return {
	"Aasim-A/scrollEOF.nvim",
	event = { "BufReadPost", "BufNewFile" },
	-- opts=true passes an empty table, enabling the plugin with its default config
	opts = true,
}
