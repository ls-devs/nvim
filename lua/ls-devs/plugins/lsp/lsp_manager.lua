return {
	"VonHeikemen/lsp-zero.nvim",
	event = "BufReadPost",
	branch = "v3.x",
	config = require("ls-devs.plugins.lsp.config.lsp_zero"),
	dependencies = {
		-- LSP
		{
			"neovim/nvim-lspconfig",
			event = "BufReadPost",
			dependencies = {
				-- LSP Enhancement
				{
					"glepnir/lspsaga.nvim",
					event = "LspAttach",
					opts = require("ls-devs.plugins.lsp.config.lspsaga"),
					dependencies = {
						{ "nvim-tree/nvim-web-devicons" },
					},
				},
			},
		},
		-- Mason & Managers
		{
			"williamboman/mason-lspconfig.nvim",
			event = "VeryLazy",
			config = require("ls-devs.plugins.lsp.config.mason_lspconfig"),
			dependencies = {
				-- Formatter
				{
					"creativenull/efmls-configs-nvim",
					version = "v1.x.x",
					config = require("ls-devs.plugins.lsp.config.efm_configs"),
				},
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
	},
}
