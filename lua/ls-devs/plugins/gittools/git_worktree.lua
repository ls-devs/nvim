return {
	"polarmutex/git-worktree.nvim",
	config = function()
		require("telescope").load_extension("git_worktree")
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ww",
			"<cmd>Telescope git_worktree<CR>",
			desc = "Telescope Git-Worktree",
			noremap = true,
			silent = true,
		},
		{
			"<leader>wc",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			desc = "Telescope Create Git-Worktree",
			noremap = true,
			silent = true,
		},
	},
}
