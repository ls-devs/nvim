-- ── luarocks ──────────────────────────────────────────────────────────────
-- Purpose : Lua package manager integration — installs Lua rocks at startup
-- Trigger : eager (priority=1000) — must load before plugins that depend on it
-- ─────────────────────────────────────────────────────────────────────────

-- Package required for :
-- Neorg
-- Rest.nvim
-- Nvim-Spider
-- Molten.nvim

return {
	"vhyrro/luarocks.nvim",
	priority = 1000,
	opts = {
		rocks = {
			"luautf8", -- Nvim-Spider
			"lua-utils.nvim", -- Neorg
			"lua-curl", -- Rest.nvim
			"nvim-nio", -- Rest.nvim
			"mimetypes", -- Rest.nvim
			"xml2lua", -- Rest.nvim
			"magick", -- Molten.nvim
		},
	},
}
