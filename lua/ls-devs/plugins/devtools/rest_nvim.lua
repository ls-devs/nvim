-- ── rest.nvim ────────────────────────────────────────────────────────────
-- Purpose : HTTP client for .http files (REST Client compatible format)
-- Trigger : ft = http
-- Note    : Depends on luarocks.nvim for native Lua library installation
-- ─────────────────────────────────────────────────────────────────────────
return {
	"rest-nvim/rest.nvim",
	ft = "http",
	dependencies = { "luarocks.nvim" },
	keys = {
		-- <leader>rh — run the HTTP request under the cursor
		{
			"<leader>rh",
			"<cmd>Rest run<CR>",
			desc = "RestNvim",
			noremap = true,
			silent = true,
		},
		-- <leader>rl — re-run the most recent request
		{
			"<leader>rl",
			"<cmd>Rest run last<CR>",
			desc = "RestNvimLast",
			noremap = true,
			silent = true,
		},
	},
}
