return {
	"VonHeikemen/lsp-zero.nvim",
	event = "VeryLazy",
	branch = "v3.x",
	config = require("ls-devs.plugins.lsp.config.lsp_zero"),
	init = function()
		vim.g.lsp_zero_ui_float_border = 0
	end,
	dependencies = {
		-- Mason & Managers
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = require("ls-devs.plugins.lsp.config.mason_tool_installer"),
			dependencies = {
				{
					"williamboman/mason-lspconfig.nvim",
					config = function()
						local lsp_zero = require("lsp-zero")
						require("mason-lspconfig").setup({
							handlers = {
								lsp_zero.default_setup,
								rust_analyzer = lsp_zero.noop,
							},
						})
					end,
					dependencies = {
						{
							"williamboman/mason.nvim",
							opts = {
								log_level = vim.log.levels.OFF,
								ui = {
									border = "rounded",
									icons = {
										package_installed = "✓",
										package_pending = "➜",
										package_uninstalled = "✗",
									},
								},
							},
						},
						{ "neovim/nvim-lspconfig" },
					},
				},
			},
		},
	},
}
