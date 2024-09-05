return {
	"stevearc/stickybuf.nvim",
	event = "BufReadPost",
	config = function()
		require("stickybuf").setup({
			get_auto_pin = function(bufnr)
				return require("stickybuf").should_auto_pin(bufnr)
			end,
		})
	end,
}
