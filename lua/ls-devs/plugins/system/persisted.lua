return {
	"olimorris/persisted.nvim",
	event = "VeryLazy",
	opts = {
		save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
		silent = false,
		use_git_branch = true,
		default_branch = "main",
		autosave = false,
		autoload = false,
		follow_cwd = true,
		telescope = {
			reset_prompt = true,
		},
	},
	keys = {
		{
			"<leader>fs",
			"<cmd>Telescope persisted<CR>",
			desc = "Telescope Sessions",
			silent = true,
			noremap = true,
		},
		{
			"<leader>ss",
			"<cmd>SessionStart<CR>",
			desc = "Start Session",
			silent = true,
			noremap = true,
		},
		{
			"<leader>sw",
			"<cmd>SessionSave<CR>",
			desc = "Session Save",
			silent = true,
			noremap = true,
		},
		{
			"<leader>sq",
			"<cmd>SessionStop<CR>",
			desc = "Stop Session",
			silent = true,
			noremap = true,
		},
		{
			"<leader>st",
			"<cmd>SessionToggle<CR>",
			desc = "Toggle Session",
			silent = true,
			noremap = true,
		},
	},
}
