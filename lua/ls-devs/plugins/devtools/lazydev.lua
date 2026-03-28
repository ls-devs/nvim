-- ── lazydev.nvim ──────────────────────────────────────────────────────────
-- Purpose : Lua type annotations and completions for Neovim config/plugin code
-- Trigger : ft = lua
-- Provides: LuaLS library augmentation, type hints for Neovim APIs
-- Note    : Library list is explicitly curated to match plugins installed in
--           this config; integrates with blink.cmp via the lazydev source
--           (cmp = false because this config uses blink.cmp, not nvim-cmp)
-- ─────────────────────────────────────────────────────────────────────────
-- WHY _G.require shows a duplicate hover entry and how we prevent it
-- ─────────────────────────────────────────────────────────────────────────
-- Two plugins override _G.require at runtime via unpack/unpack_len, which
-- makes lua_ls infer a second definition with up to 10 unknown return values:
--
--   1. lazy.nvim/lua/lazy/init.lua  — `_G.require = function(modname)`
--      inside `profile_require()`, returns `vim.F.unpack_len(ret)` which
--      calls `unpack(t, 1, t.n)` → lua_ls infers 10 unknowns.
--
--   2. snacks/profiler/core.lua — `_G.require = M.require` where
--      `M.require` returns `unpack(ret)` → same 10-unknown inference.
--
-- FIX for lazy.nvim (always in global workspace when "lazy.nvim" is listed
-- without a filter):
--   Replace "lazy.nvim" with targeted sub-paths that DO NOT include init.lua:
--   • "lazy.nvim/lua/lazy/types.lua"  — LazySpec, LazyPlugin, LazyPluginSpec…
--   • "lazy.nvim/lua/lazy/core"       — LazyConfig and core utility types
--   lazydev's ws:add() resolves plugin names and handles both file and dir
--   entries; neither of these paths contains _G.require assignments.
--
-- FIX for snacks (dynamically added when a buffer contains require("snacks")):
--   Monkey-patch buf.on_mod to return early for all "snacks*" module names.
--   The patch is applied AFTER setup() but BEFORE buf.setup() (which is
--   vim.schedule'd), so it's in place before any buffer is ever scanned.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"folke/lazydev.nvim",
	ft = "lua",
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("lazydev").setup(opts)
		-- Patch buf.on_mod to silently drop snacks.* modules so snacks.nvim
		-- is never added to the lua_ls workspace library.  The patch runs
		-- synchronously here; buf.setup() is vim.schedule'd and fires later,
		-- so the patched function is guaranteed to be in place before any
		-- buffer scan happens.
		local buf = require("lazydev.buf")
		local orig_on_mod = buf.on_mod
		buf.on_mod = function(b, modname)
			if modname:match("^snacks") then
				return
			end
			return orig_on_mod(b, modname)
		end
	end,
	opts = {
		debug = false,
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } }, -- luv types, only when vim.uv is referenced
			-- lazy.nvim: use targeted sub-paths instead of the full plugin root.
			-- "lazy.nvim" (full root) would include lua/lazy/init.lua which has
			-- _G.require = function(modname) … return vim.F.unpack_len(ret) end,
			-- causing a duplicate hover entry with 10 unknown return values.
			-- types.lua has all user-facing type aliases (LazySpec, LazyPlugin…).
			-- core/ has LazyConfig and other core types.  Neither includes init.lua.
			"lazy.nvim/lua/lazy/types.lua",
			"lazy.nvim/lua/lazy/core",
			"catppuccin",
			"plenary.nvim",
			"fidget.nvim",
			"nvim-web-devicons",
			"lualine.nvim",
			"nvim-various-textobjs",
			"statuscol.nvim",
			"neotab.nvim",
			"nvim-ufo",
			"blink.cmp",
			"snacks.nvim",
		},
		integrations = {
			lspconfig = true,
			cmp = false,
			coq = false,
		},
	},
}
