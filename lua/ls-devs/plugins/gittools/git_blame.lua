return {
	"f-person/git-blame.nvim",
	event = "BufReadPost",
	opts = {
		enabled = true,
	},
	init = function()
		vim.g.gitblame_highlight_group = "Blame"
		vim.g.gitblame_message_template = "|   <author> • <date> • <summary> |"
		vim.g.gitblame_message_when_not_committed = "|   Not committed Yet |"
		vim.g.gitblame_date_format = "%x"
		vim.g.gitblame_delay = 1000
	end,
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
}
