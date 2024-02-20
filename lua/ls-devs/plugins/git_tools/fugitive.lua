return {
	"tpope/vim-fugitive",
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
	cmd = "Git",
}
