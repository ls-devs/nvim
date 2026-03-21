-- ── git-worktree.nvim ─────────────────────────────────────────────────────
-- Purpose : Git worktree management surfaced through Telescope
-- Trigger : keys = { "<leader>ww", "<leader>wc" }
-- Note    : polarmutex/git-worktree.nvim is the maintained fork of
--           ThePrimeagen/git-worktree.nvim.
-- ──────────────────────────────────────────────────────────────────────────
return {
	"polarmutex/git-worktree.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		require("telescope").load_extension("git_worktree")
	end,

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
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
}
