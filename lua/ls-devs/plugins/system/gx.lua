return {
	"chrishrb/gx.nvim",
	cmd = { "Browse" },
	opts = {
		handlers = {
			plugin = true,
			github = true,
			brewfile = true,
			package_json = true,
			search = false,
		},
		handler_options = {
			search_engine = "google",
		},
	},
	init = function()
		vim.g.netrw_nogx = 1
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
	submodules = false,
}
