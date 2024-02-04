return {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
	cond = function()
		if vim.fn.exists("$TMUX") == 0 then
			return false
		else
			return true
		end
	end,
}
