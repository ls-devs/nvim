-- ── schemastore ───────────────────────────────────────────────────────────
-- Purpose : Provides JSON/YAML schema catalog consumed by lsp/jsonls.lua
-- Trigger : lazy (loaded on demand when jsonls config is evaluated)
-- ──────────────────────────────────────────────────────────────────────────
return {
	"b0o/schemastore.nvim",
	lazy = true,
}
