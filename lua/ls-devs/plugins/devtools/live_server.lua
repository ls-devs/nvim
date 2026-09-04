-- ── live-server ──────────────────────────────────────────────────────────
-- Purpose : HTML live-reload dev server for in-browser preview while editing
-- Trigger : cmd = LiveServerStart / LiveServerStop / LiveServerToggle
-- Note    : Since v0.2.0 the server runs entirely in Lua on libuv — there is
--           no npm dependency, and `require("live-server").setup()` was
--           removed (it now only logs an error). Configuration goes through
--           `vim.g.live_server`, set in `init` before the plugin loads.
--           Upstream development moved to Forgejo; GitHub is a read-only
--           mirror (see `:help live-server-migration`).
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"barrett-ruth/live-server.nvim",
	cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
	init = function()
		vim.g.live_server = {
			port = 5500,
			browser = true,
			debounce = 120,
			ignore = { "node_modules", ".git" },
			css_inject = true, -- CSS changes don't require full page reload
		}
	end,
	keys = {
		{ "<leader>lS", "<cmd>LiveServerStart<CR>", desc = "Live Server: Start", noremap = true, silent = true },
		{ "<leader>lX", "<cmd>LiveServerStop<CR>", desc = "Live Server: Stop", noremap = true, silent = true },
		{ "<leader>lT", "<cmd>LiveServerToggle<CR>", desc = "Live Server: Toggle", noremap = true, silent = true },
	},
}
