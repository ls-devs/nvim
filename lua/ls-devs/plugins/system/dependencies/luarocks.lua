-- ── luarocks ──────────────────────────────────────────────────────────────
-- Purpose : Lua package manager integration — installs Lua rocks at startup
-- Trigger : eager (priority=1000) — must load before plugins that depend on it
-- ─────────────────────────────────────────────────────────────────────────

-- Package required for :
-- Nvim-Spider

return {
	"vhyrro/luarocks.nvim",
	priority = 1000,
	opts = {
		rocks = {
			"luautf8", -- Nvim-Spider
		},
	},
}
