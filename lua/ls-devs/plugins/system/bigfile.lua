return {
	"LunarVim/bigfile.nvim",
	cond = function()
		local file = vim.fn.expand("%:p")
		if file == "" then
			return false
		end
		local stat = vim.loop.fs_stat(file)
		return stat and stat.size > 6 * 1024 * 1024
	end,
	config = function()
		require("bigfile").enable()
	end,
}
