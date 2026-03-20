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
		default_mappings = false,
		default_commands = true,
		disable_diagnostics = false,
		list_opener = "copen",
		highlights = {
			incoming = "DiffAdd",
			current = "DiffText",
		},
	},
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
}
