local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "ls-devs.plugins.completion" },
		{ import = "ls-devs.plugins.completion.completion_modules" },
		{ import = "ls-devs.plugins.devtools" },
		{ import = "ls-devs.plugins.gittools" },
		{ import = "ls-devs.plugins.lsp" },
		{ import = "ls-devs.plugins.movement" },
		{ import = "ls-devs.plugins.preview" },
		{ import = "ls-devs.plugins.system" },
		{ import = "ls-devs.plugins.system.telescope_extensions" },
		{ import = "ls-devs.plugins.system.treesitter_modules" },
		{ import = "ls-devs.plugins.ui" },
		{ import = "ls-devs.plugins.utilities" },
	},
	defaults = {
		lazy = true,
	},
	install = {
		missing = true,
		colorscheme = { "catppuccin" },
	},
	ui = {
		border = "rounded",
		backdrop = 100,
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
		browser = "wslview",
	},
	checker = {
		enabled = true,
		notify = true,
		check_pinned = true,
		frequency = 3600,
	},
	change_detection = {
		enabled = true,
		notify = true,
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true,
		rtp = {
			reset = true,
			paths = {},
			disabled_plugins = {},
		},
	},
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		skip_if_doc_exists = true,
	},
	profiling = {
		loader = true,
		require = true,
	},
})
