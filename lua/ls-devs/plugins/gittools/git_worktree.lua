return {
	"polarmutex/git-worktree.nvim",
	config = function()
		require("git-worktree").setup({
			update_on_change_command = "",
		})
		require("telescope").load_extension("git_worktree")
		require("git-worktree").on_tree_change(function(op, metadata)
			if op == require("git-worktree").Operations.Switch then
				print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
			end
			local Path = require("plenary.path")
			if op == require("git_worktree").Operations.Create then
				-- If we're dealing with create, the path is relative to the worktree and not absolute
				-- so we need to convert it to an absolute path.
				local path = metadata.path
				if not Path:new(path):is_absolute() then
					path = Path:new():absolute()
					if path:sub(-#"/") == "/" then
						path = string.sub(path, 1, string.len(path) - 1)
					end
				end
				-- local branch = branchname(metadata.path)
				local base_path = string.match(path, "(.-)%.git") .. ".git"
				local worktree_path = base_path .. "/" .. metadata.path .. "/"
				local gitignored_path = base_path .. "/gitignored"
				local link_gitignored = "ln -s " .. gitignored_path .. "/{*,.*} " .. worktree_path
				if vim.fn.isdirectory(gitignored_path) == 1 then
					os.execute(link_gitignored)
				end
			end
		end)
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
}
