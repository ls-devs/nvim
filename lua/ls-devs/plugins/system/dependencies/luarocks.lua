-- ── luarocks ──────────────────────────────────────────────────────────────
-- Purpose : exposes the `lua-utf8` rock so nvim-spider's w/e/b motions are
--           codepoint-aware instead of byte-wise (matters for accented text).
-- Trigger : none of its own; pulled in as a dependency of nvim-spider
--           (movement/nvim_spider.lua), which must see the rock on
--           `package.cpath` before it requires spider.extras.utf8-support.
-- Note    : upstream has been dormant since 2024-04 while its build step
--           still compiles luarocks from git master, so `setup()` is only
--           used on first install. See the comment in `config` below.
--           If the rock ever disappears, nvim-spider degrades gracefully to
--           byte-wise string handling.
-- ─────────────────────────────────────────────────────────────────────────

---@type LazySpec
return {
	"vhyrro/luarocks.nvim",
	lazy = true,
	config = function()
		-- `luarocks-nvim.paths` is pure path arithmetic: no system calls.
		local paths = require("luarocks-nvim.paths")

		package.path = package.path .. ";" .. table.concat(paths.share, ";")
		package.cpath = package.cpath .. ";" .. paths.lib
		vim.opt.rtp:append(paths.rtp_lib)

		-- Fast path. Everything nvim-spider needs is the rock tree on the
		-- search paths, which is now done. Calling luarocks.nvim's setup()
		-- here instead would cost ~110 ms of blocking `luarocks list
		-- --porcelain` on every load (i.e. on the first w/e/b press of the
		-- session) and would also require `luarocks.loader`, which the
		-- vendored luarocks build cannot resolve without the dkjson rock.
		if pcall(require, "lua-utf8") then
			return
		end

		-- Slow path: fresh install, or a wiped/rebuilt .rocks tree. Hand over
		-- to luarocks.nvim so it builds the tree and installs the rocks.
		-- dkjson is listed because luarocks git master requires it for
		-- `luarocks.core.persist`, but its `make install` does not vendor it.
		require("luarocks-nvim").setup({
			rocks = {
				"luautf8", -- nvim-spider
				"dkjson", -- required by the luarocks package loader itself
			},
		})
	end,
}
