---@diagnostic disable: undefined-global
-- ── core/lazy ────────────────────────────────────────────────────────────
-- Purpose : Bootstrap lazy.nvim and register all plugin specs.
-- Trigger : Loaded at startup by core/init.lua
-- ─────────────────────────────────────────────────────────────────────────

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugin Spec Imports ───────────────────────────────────────────────────
---@type LazyConfig
require("lazy").setup({
	spec = {
		{ import = "ls-devs.plugins.completion" },
		{ import = "ls-devs.plugins.devtools" },
		{ import = "ls-devs.plugins.gittools" },
		{ import = "ls-devs.plugins.lsp" },
		{ import = "ls-devs.plugins.movement" },
		{ import = "ls-devs.plugins.system" },
		{ import = "ls-devs.plugins.system.dependencies" },
		{ import = "ls-devs.plugins.system.treesitter_modules" },
		{ import = "ls-devs.plugins.ui" },
		{ import = "ls-devs.plugins.utilities" },
	},
	defaults = {
		lazy = true, -- every plugin is lazy-loaded unless it declares an explicit trigger
	},
	install = {
		missing = true,
		colorscheme = { "catppuccin" },
	},
	ui = {
		border = "rounded",
		backdrop = 100, -- fully opaque backdrop behind the Lazy float
		size = { width = 0.8, height = 0.8 },
		wrap = true,
		icons = {
			cmd = " ",
			config = "",
			event = "",
			ft = " ",
			init = " ",
			import = " ",
			keys = " ",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
			plugin = " ",
			runtime = " ",
			require = "󰢱 ",
			source = " ",
			start = "",
			task = "󰄳 ",
			list = {
				"●",
				"➜",
				"★",
				"‒",
			},
		},
		browser = "wslview", -- WSL-compatible browser for opening plugin URLs from the Lazy UI
	},
	-- ── Update Checker ────────────────────────────────────────────────────────
	checker = {
		enabled = true,
		notify = true,
		check_pinned = false, -- skip version-pinned plugins when scanning for updates
		frequency = 86400, -- check once per day (value in seconds)
	},
	change_detection = {
		enabled = true,
		notify = true,
	},
	-- ── Performance ───────────────────────────────────────────────────────────
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true,
		rtp = {
			reset = true,
			paths = {},
			-- disable unused built-in Vim plugins to reduce startup overhead
			disabled_plugins = {
				"gzip",
				"zip",
				"zipPlugin",
				"tar",
				"tarPlugin",
				"getscript",
				"getscriptPlugin",
				"vimball",
				"vimballPlugin",
				"2html_plugin",
				"logipat",
				"rrhelper",
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",
				"matchit", -- vim-matchup fully replaces matchit (and matchparen)
				"matchparen", -- vim-matchup takes over matchparen when it loads
				"spellfile_plugin", -- not using spell-file downloads; avoids silent network call on z=
				"tohtml",
				"tutor",
			},
		},
	},
	-- ── README Cache ──────────────────────────────────────────────────────────
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		skip_if_doc_exists = true,
	},
	-- ── Profiling ─────────────────────────────────────────────────────────────
	profiling = {
		loader = false, -- set true to profile the module loader
		require = false, -- set true to profile require() call sites
	},
})
