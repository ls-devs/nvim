return {
	"VonHeikemen/lsp-zero.nvim",
	event = "VeryLazy",
	branch = "v3.x",
	config = require("ls-devs.plugins.lsp.config.lsp_zero"),
	dependencies = {
		-- Mason & Managers
		{
			"williamboman/mason-lspconfig.nvim",
			config = require("ls-devs.plugins.lsp.config.mason_lspconfig"),
			dependencies = {
				{
					"jay-babu/mason-nvim-dap.nvim",
					config = require("ls-devs.plugins.lsp.config.mason_nvim_dap"),
				},
				{
					"williamboman/mason.nvim",
					config = require("ls-devs.plugins.lsp.config.mason"),
				},
				{ "neovim/nvim-lspconfig" },
			},
		},
	},
}
