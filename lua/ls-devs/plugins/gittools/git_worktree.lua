return {
	"ThePrimeagen/git-worktree.nvim",
	config = function()
		require("telescope").load_extension("git_worktree")
		require("git-worktree").on_tree_change(function(op, metadata)
			if op == require("git-worktree").Operations.Switch then
				print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
			end
		end)
	end,

	keys = {
		{
			"<leader>gw",
			"<cmd>Telescope git_worktree<CR>",
			desc = "Telescope Git-Worktree",
			noremap = true,
			silent = true,
		},
		{
			"<leader>cw",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			desc = "Telescope Create Git-Worktree",
			noremap = true,
			silent = true,
		},
	},
}
