-- ── mini.icons ────────────────────────────────────────────────────────────
-- Purpose : Faster icon resolution replacing nvim-web-devicons
-- Trigger : lazy = false (needed before any plugin requiring icons loads)
-- Note    : package.preload shim intercepts require("nvim-web-devicons")
--           calls transparently — all plugins (neo-tree, lualine, tabby,
--           trouble, lspsaga) continue working without any config changes
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"echasnovski/mini.icons",
	lazy = false,
	priority = 900, -- after snacks (1000) but before icon-consuming plugins
	opts = {},
	init = function()
		-- Redirect any require("nvim-web-devicons") call to mini.icons before
		-- the module is loaded so plugins get the faster implementation
		---@return table
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
