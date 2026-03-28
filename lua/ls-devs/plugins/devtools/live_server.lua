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
	init = function()
		vim.g.live_server = {
			port = 5500,
			browser = true,
			debounce = 120,
			ignore = { "node_modules", ".git" },
			css_inject = true, -- CSS changes don't require full page reload
		}
	end,
	config = true,
	keys = {
		{ "<leader>lS", "<cmd>LiveServerStart<CR>", desc = "Live Server: Start", noremap = true, silent = true },
		{ "<leader>lX", "<cmd>LiveServerStop<CR>", desc = "Live Server: Stop", noremap = true, silent = true },
	},
}
