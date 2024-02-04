return {
	"VonHeikemen/lsp-zero.nvim",
	event = "BufReadPost",
	branch = "v3.x",
	config = require("ls-devs.plugins.lsp.config.lsp_zero"),
	dependencies = {
		-- Mason & Managers
		{
			"williamboman/mason-lspconfig.nvim",
			event = "VeryLazy",
			config = require("ls-devs.plugins.lsp.config.mason_lspconfig"),
			dependencies = {
				{
					"jay-babu/mason-nvim-dap.nvim",
					event = "VeryLazy",
					config = require("ls-devs.plugins.lsp.config.mason_nvim_dap"),
				},
				{
					"williamboman/mason.nvim",
					event = "VeryLazy",
					config = require("ls-devs.plugins.lsp.config.mason"),
				},
			},
		},
		-- LSP
		{
			"neovim/nvim-lspconfig",
			event = "BufReadPost",
		},
		-- LSP Enhancement
		{
			"glepnir/lspsaga.nvim",
			event = "LspAttach",
			opts = require("ls-devs.plugins.lsp.config.lspsaga"),
			dependencies = {
				{ "nvim-tree/nvim-web-devicons" },
			},
		},
		-- Formatter
		{
			"creativenull/efmls-configs-nvim",
			version = "v1.x.x",
		},
	},
}
