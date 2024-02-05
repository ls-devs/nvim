return {
	"utilyre/sentiment.nvim",
	version = "*",
	event = "VeryLazy",
	init = function()
		vim.g.loaded_matchparen = 1
	end,
}
