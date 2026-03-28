-- ── kulala.nvim ──────────────────────────────────────────────────────────
-- Purpose : HTTP client for .http files (REST Client compatible format)
-- Trigger : ft = http
-- Replaces: rest.nvim (removed luarocks deps: lua-curl, nvim-nio, mimetypes, xml2lua)
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	opts = {
		default_view = "body",
		display_mode = "split",
		split_direction = "vertical",
		show_icons = "on_request",
		default_env = "dev", -- use the @dev environment block by default when no env is set
		global_keymaps = false, -- disable kulala's own global keymaps (we define our own below)
		lsp = {
			enable = true, -- enable kulala's built-in language server for .http files
			filetypes = { "http", "rest" },
		},
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
		-- <leader>rj — jump to next request in file
		{
			"<leader>rj",
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
