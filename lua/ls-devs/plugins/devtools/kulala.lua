-- ── kulala.nvim ──────────────────────────────────────────────────────────
-- Purpose : HTTP client for .http files (REST Client compatible format)
-- Trigger : ft = http
-- Replaces: rest.nvim (removed luarocks deps: lua-curl, nvim-nio, mimetypes, xml2lua)
-- ─────────────────────────────────────────────────────────────────────────
return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	opts = {
		default_view = "body",
		display_mode = "split",
		split_direction = "vertical",
		show_icons = "on_request",
	},
	keys = {
		-- <leader>rh — run the HTTP request under the cursor
		{
			"<leader>rh",
			function()
				require("kulala").run()
			end,
			desc = "Kulala Run",
			ft = "http",
			noremap = true,
			silent = true,
		},
		-- <leader>rl — re-run the most recent request
		{
			"<leader>rl",
			function()
				require("kulala").replay()
			end,
			desc = "Kulala Replay",
			ft = "http",
			noremap = true,
			silent = true,
		},
		-- <leader>rn — jump to next request in file
		{
			"<leader>rn",
			function()
				require("kulala").jump_next()
			end,
			desc = "Kulala Next Request",
			ft = "http",
			noremap = true,
			silent = true,
		},
		-- <leader>rp — jump to previous request in file
		{
			"<leader>rp",
			function()
				require("kulala").jump_prev()
			end,
			desc = "Kulala Prev Request",
			ft = "http",
			noremap = true,
			silent = true,
		},
	},
}
