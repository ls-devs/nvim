-- ── live-server ──────────────────────────────────────────────────────────
-- Purpose : HTML live-reload dev server for in-browser preview while editing
-- Trigger : cmd = LiveServerStart / LiveServerStop
-- Note    : Installs live-server globally via pnpm on first build
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"barrett-ruth/live-server.nvim",
	build = "pnpm add -g live-server",
	cmd = { "LiveServerStart", "LiveServerStop" },
	config = true,
}
