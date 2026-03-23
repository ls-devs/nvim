-- ── todo-comments.nvim ───────────────────────────────────────────────────────
-- Purpose : Highlights and searches TODO/FIXME/HACK/NOTE/WARN/PERF/TEST
--           comment keywords across the project.
-- Trigger : BufReadPost
-- Note    : <leader>T=TodoTrouble (list), <leader>TT=Snacks.picker.todo_comments (search).
--           search="" suppresses the raw-regex badge; --regexp passes the exact pattern.
-- ─────────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"folke/todo-comments.nvim",
	event = "BufReadPost",
	opts = {},
	dependencies = { "plenary.nvim", lazy = true },
	keys = {
		{
			"<leader>T",
			"<cmd>TodoTrouble<CR>",
			desc = "TodoTrouble",
			silent = true,
			noremap = true,
		},
		{
			"<leader>TT",
			function()
				-- Pass the precise todo-comments regex via rg --regexp (so word-boundary
				-- and colon requirement are preserved) while keeping filter.search = ""
				-- to suppress the raw-regex badge in the picker input.
				-- need_search=false bypasses the empty-search early-exit in the grep finder.
				-- dirs=cwd ensures rg has an explicit path (filter.search="" would otherwise
				-- produce `rg ... -- ""` with no real path to search).
				local tc = require("todo-comments.config")
				Snacks.picker.todo_comments({
					search = "",
					need_search = false,
					args = { "--regexp", tc.search_regex(vim.tbl_keys(tc.keywords)) },
					dirs = { vim.uv.cwd() or "." },
				})
			end,
			desc = "Todo Picker",
			silent = true,
			noremap = true,
		},
	},
}
