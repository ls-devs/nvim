return {
	"utilyre/sentiment.nvim",
	event = "BufReadPost",
	init = function()
		vim.g.loaded_matchparen = 1
	end,
}
