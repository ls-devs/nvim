-- ── gx ────────────────────────────────────────────────────────────────────
-- Purpose : Smart URL/plugin/repo opener (replaces netrw gx)
-- Trigger : Browse cmd (the gx keymap is wired in treesitter.lua)
-- Note    : vim.g.netrw_nogx=1 disables netrw's built-in gx so this plugin owns it
-- ─────────────────────────────────────────────────────────────────────────
return {
	"chrishrb/gx.nvim",
	cmd = { "Browse" },
	opts = {
		handlers = {
			plugin = true,
			github = true,
			brewfile = true,
			package_json = true,
			search = false, -- disable fallback web search when no URL is found
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
		vim.g.netrw_nogx = 1 -- prevent netrw from claiming the gx mapping
	end,
	dependencies = { "plenary.nvim", lazy = true },
	submodules = false, -- skip recursive git submodule init for the plugin repo
}
