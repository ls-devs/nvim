require("ls-devs.config.options")

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
		{ import = "ls-devs.plugins.dev_tools" },
		{ import = "ls-devs.plugins.git_tools" },
		{ import = "ls-devs.plugins.highlights" },
		{ import = "ls-devs.plugins.keymaps" },
		{ import = "ls-devs.plugins.lsp" },
		{ import = "ls-devs.plugins.movements" },
		{ import = "ls-devs.plugins.preview" },
		{ import = "ls-devs.plugins.system" },
		{ import = "ls-devs.plugins.system.telescope_extensions" },
		{ import = "ls-devs.plugins.ui" },
		{ import = "ls-devs.plugins.utilities" },
	},
	defaults = {
		lazy = true,
		-- version = "*",
	},
	ui = {
		border = "rounded",
		size = { width = 0.85, height = 0.8 },
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
	},
	install = {
		missing = true,
		colorscheme = { "tokyonight" },
	},
	checker = {
		enabled = true,
		notify = true,
	},
	readme = {
		enabled = true,
	},
})
