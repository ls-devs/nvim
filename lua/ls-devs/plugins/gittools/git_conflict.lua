-- ── git-conflict.nvim ─────────────────────────────────────────────────────
-- Purpose : Visual conflict resolution with choose-ours/theirs/both/none
-- Trigger : event = { "BufReadPost", "BufNewFile" }
-- Note    : default_mappings=false; all keymaps use <leader>gc* prefix and
--           ]x/[x for next/prev conflict navigation.
-- ──────────────────────────────────────────────────────────────────────────
return {
	"akinsho/git-conflict.nvim",
	event = { "BufReadPost", "BufNewFile" },
	version = "*",
	keys = {
		{
			"<leader>gco",
			"<cmd>GitConflictChooseOurs<cr>",
			desc = "Git Conflict: Choose Ours",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gct",
			"<cmd>GitConflictChooseTheirs<cr>",
			desc = "Git Conflict: Choose Theirs",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gcb",
			"<cmd>GitConflictChooseBoth<cr>",
			desc = "Git Conflict: Choose Both",
			noremap = true,
			silent = true,
		},
		{
			"<leader>gcn",
			"<cmd>GitConflictChooseNone<cr>",
			desc = "Git Conflict: Choose None",
			noremap = true,
			silent = true,
		},
		{ "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Git Conflict: Next", noremap = true, silent = true },
		{ "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Git Conflict: Prev", noremap = true, silent = true },
		{ "<leader>gcl", "<cmd>GitConflictListQf<cr>", desc = "Git Conflict: List All", noremap = true, silent = true },
	},
	opts = {
		default_mappings = false, -- all resolution keymaps are defined manually in the keys table above
		default_commands = true,
		disable_diagnostics = false,
		list_opener = "copen", -- open conflict list in the standard quickfix window
		-- reuse built-in diff highlight groups for conflict marker highlighting
		highlights = {
			incoming = "DiffAdd",
			current = "DiffText",
		},
	},
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
}
