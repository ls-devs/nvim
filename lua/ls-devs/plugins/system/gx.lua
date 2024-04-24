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
	config = function(_, opts)
		local browser = function()
			if vim.fn.has("wsl") then
				return "wslview"
			else
				return "os_specific"
			end
		end
		require("gx").setup(vim.tbl_deep_extend("force", opts, {
			open_browser_app = browser(),
		}))
	end,
	init = function()
		vim.g.netrw_nogx = 1
	end,
	submodules = false,
}
