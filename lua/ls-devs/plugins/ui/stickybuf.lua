return {
	"stevearc/stickybuf.nvim",
	event = "BufReadPre",
	config = function()
		require("stickybuf").setup({
			get_auto_pin = function(bufnr)
				if vim.bo.filetype ~= "terminal" then
					return require("stickybuf").should_auto_pin(bufnr)
				end
			end,
		})
	end,
}
