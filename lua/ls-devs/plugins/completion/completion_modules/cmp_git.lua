return {
	"petertriho/cmp-git",
	ft = "gitcommit",
	opts = {
		filetypes = { "gitcommit", "octo" },
		remotes = { "upstream", "origin" },
		enableRemoteUrlRewrites = false,
		git = {
			commits = {
				limit = 100,
			},
		},
		github = {
			hosts = {},
			issues = {
				fields = { "title", "number", "body", "updatedAt", "state" },
				filter = "all",
				limit = 100,
				state = "open",
			},
			mentions = {
				limit = 100,
			},
			pull_requests = {
				fields = { "title", "number", "body", "updatedAt", "state" },
				limit = 100,
				state = "open",
			},
		},
		gitlab = {
			hosts = {},
			issues = {
				limit = 100,
				state = "opened",
			},
			mentions = {
				limit = 100,
			},
			merge_requests = {
				limit = 100,
				state = "opened",
			},
		},
		trigger_actions = {
			{
				debug_name = "git_commits",
				trigger_character = ":",
				action = function(sources, trigger_char, callback, params, git_info)
					return sources.git:get_commits(callback, params, trigger_char)
				end,
			},
			{
				debug_name = "gitlab_issues",
				trigger_character = "#",
				action = function(sources, trigger_char, callback, params, git_info)
					return sources.gitlab:get_issues(callback, git_info, trigger_char)
				end,
			},
			{
				debug_name = "gitlab_mentions",
				trigger_character = "@",
				action = function(sources, trigger_char, callback, params, git_info)
					return sources.gitlab:get_mentions(callback, git_info, trigger_char)
				end,
			},
			{
				debug_name = "gitlab_mrs",
				trigger_character = "!",
				action = function(sources, trigger_char, callback, params, git_info)
					return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
				end,
			},
			{
				debug_name = "github_issues_and_pr",
				trigger_character = "#",
				action = function(sources, trigger_char, callback, params, git_info)
					return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
				end,
			},
			{
				debug_name = "github_mentions",
				trigger_character = "@",
				action = function(sources, trigger_char, callback, params, git_info)
					return sources.github:get_mentions(callback, git_info, trigger_char)
				end,
			},
		},
	},
	config = function(_, opts)
		local format = require("cmp_git.format")
		local sort = require("cmp_git.sort")
		require("cmp_git").setup(vim.tbl_deep_extend("force", opts, {
			git = {
				commits = {
					sort_by = sort.git.commits,
					format = format.git.commits,
				},
			},
			github = {
				hosts = {},
				issues = {
					sort_by = sort.github.issues,
					format = format.github.issues,
				},
				mentions = {
					sort_by = sort.github.mentions,
					format = format.github.mentions,
				},
				pull_requests = {
					sort_by = sort.github.pull_requests,
					format = format.github.pull_requests,
				},
			},
			gitlab = {
				hosts = {},
				issues = {
					sort_by = sort.gitlab.issues,
					format = format.gitlab.issues,
				},
				mentions = {
					sort_by = sort.gitlab.mentions,
					format = format.gitlab.mentions,
				},
				merge_requests = {
					sort_by = sort.gitlab.merge_requests,
					format = format.gitlab.merge_requests,
				},
			},
		}))
	end,
}
