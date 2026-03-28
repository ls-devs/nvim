-- ── git-worktree.nvim ─────────────────────────────────────────────────────
-- Purpose : Git worktree management surfaced through Snacks.picker
-- Trigger : keys = { "<leader>ww", "<leader>wc" }
-- Note    : polarmutex/git-worktree.nvim is the maintained fork of
--           ThePrimeagen/git-worktree.nvim. Picker uses a custom finder that
--           runs `git worktree list --porcelain` and exposes switch/delete
--           actions; <leader>wc prompts for path+branch then creates a worktree.
-- ──────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"polarmutex/git-worktree.nvim",
	keys = {
		{
			"<leader>ww",
			function()
				local gw = require("git-worktree")

				-- Parse `git worktree list --porcelain` output into a list of tables.
				local function list_worktrees()
					local lines = vim.fn.systemlist("git worktree list --porcelain")
					local worktrees, curr = {}, {}
					for _, line in ipairs(lines) do
						if line == "" then
							if curr.path then
								table.insert(worktrees, curr)
							end
							curr = {}
						elseif line:match("^worktree ") then
							curr.path = line:sub(#"worktree " + 1)
						elseif line:match("^HEAD ") then
							curr.head = line:sub(#"HEAD " + 1)
						elseif line:match("^branch ") then
							curr.branch = line:match("^branch refs/heads/(.+)") or line:sub(#"branch " + 1)
						elseif line == "bare" then
							curr.bare = true
						end
					end
					if curr.path then
						table.insert(worktrees, curr)
					end
					return worktrees
				end

				local items = {}
				for i, wt in ipairs(list_worktrees()) do
					local label = wt.branch or (wt.head and wt.head:sub(1, 7)) or "detached"
					items[i] = {
						idx = i,
						score = 0,
						text = label .. "  " .. wt.path,
						_path = wt.path,
						_branch = wt.branch,
					}
				end

				Snacks.picker.pick({
					title = "Git Worktrees",
					items = items,
					format = function(item)
						local branch = item._branch or item.text:match("^(%S+)")
						local path = item._path
						return {
							{ branch, "SnacksPickerLabel" },
							{ "  " .. path, "SnacksPickerDir" },
						}
					end,
					confirm = function(picker, item)
						picker:close()
						gw.switch_worktree(item._path)
					end,
					actions = {
						delete = {
							action = function(picker, item)
								picker:close()
								gw.delete_worktree(item._path, false, {})
							end,
						},
					},
					win = {
						input = {
							keys = { ["<C-d>"] = { "delete", mode = { "i", "n" }, desc = "Delete worktree" } },
						},
					},
				})
			end,
			desc = "Git Worktrees",
			noremap = true,
			silent = true,
		},
		{
			"<leader>wc",
			function()
				vim.ui.input({ prompt = "Worktree path: " }, function(path)
					if not path or path == "" then
						return
					end
					vim.ui.input({ prompt = "Branch name: " }, function(branch)
						if not branch or branch == "" then
							return
						end
						require("git-worktree").create_worktree(path, branch)
					end)
				end)
			end,
			desc = "Create Git Worktree",
			noremap = true,
			silent = true,
		},
	},
	---@return boolean
	cond = function()
		-- Search upward for .git dir (normal repo) or .git file (worktree).
		-- isdirectory() always returns 0 inside a worktree (.git is a file),
		-- which would make this plugin permanently disabled where it's needed.
		return vim.fn.finddir(".git", ".;") ~= "" or vim.fn.findfile(".git", ".;") ~= ""
	end,
}

