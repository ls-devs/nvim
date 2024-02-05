return {
	"VonHeikemen/lsp-zero.nvim",
	event = "VeryLazy",
	branch = "v3.x",
	config = require("ls-devs.plugins.lsp.config.lsp_zero"),
	dependencies = {
		-- Mason & Managers
		{
			"williamboman/mason-lspconfig.nvim",
			opts = require("ls-devs.plugins.lsp.config.mason_lspconfig").opts,
			config = function(_, opts)
				require("ls-devs.plugins.lsp.config.mason_lspconfig").config(opts)
			end,
			dependencies = {
				{
					"jay-babu/mason-nvim-dap.nvim",
					opts = require("ls-devs.plugins.lsp.config.mason_nvim_dap"),
				},
				{
					"williamboman/mason.nvim",
					opts = require("ls-devs.plugins.lsp.config.mason"),
				},
				{ "neovim/nvim-lspconfig" },
			},
		},
	},
}
