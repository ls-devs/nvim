return {
	"ls-devs/git-worktree.nvim",
	-- branch = "v2",
	config = function()
		require("git-worktree").setup({
			update_on_change_command = "",
			on_tree_change = function(op, metadata)
				if op == require("git-worktree").Operations.Switch then
					print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
				end
				local Path = require("plenary.path")
				if op == require("git-worktree").Operations.Create then
					local path = metadata.path
					if not Path:new(path):is_absolute() then
						path = Path:new():absolute()
						if path:sub(-#"/") == "/" then
							path = string.sub(path, 1, string.len(path) - 1)
						end
					end
					local base_path = string.match(path, "(.-)%.git") .. ".git"
					local worktree_path = base_path .. "/" .. metadata.path .. "/"
					local gitignored_path = base_path .. "/gitignored"
					local link_gitignored = "ln -s " .. gitignored_path .. "/{*,.*} " .. worktree_path
					if vim.fn.isdirectory(gitignored_path) == 1 then
						os.execute(link_gitignored)
					end
				end
			end,
		})
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
}
