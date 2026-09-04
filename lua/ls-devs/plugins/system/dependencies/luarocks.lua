-- ── luarocks ──────────────────────────────────────────────────────────────
-- Purpose : Lua package manager integration — installs Lua rocks
-- Trigger : none of its own; pulled in as a dependency of nvim-spider
--           (movement/nvim_spider.lua), which needs the lua-utf8 rock.
-- Note    : upstream has been dormant since 2024-04; if it ever breaks,
--           nvim-spider degrades gracefully to byte-wise string handling.
-- ─────────────────────────────────────────────────────────────────────────

---@type LazySpec
return {
	"vhyrro/luarocks.nvim",
	lazy = true,
	opts = {
		rocks = {
			"luautf8", -- Nvim-Spider
		},
	},
}
