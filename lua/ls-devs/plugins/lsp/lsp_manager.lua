return {
	"VonHeikemen/lsp-zero.nvim",
	event = "VeryLazy",
	branch = "v3.x",
	config = require("ls-devs.plugins.lsp.config.lsp_zero"),
	dependencies = {
		-- Mason & Managers
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = require("ls-devs.plugins.lsp.config.mason_tool_installer"),
			config = function(_, opts)
				require("mason-tool-installer").setup(opts)
				vim.api.nvim_command("MasonToolsUpdate")
			end,
			dependencies = {
				{
					"williamboman/mason-lspconfig.nvim",
					config = function()
						local lsp_zero = require("lsp-zero")
						require("mason-lspconfig").setup({
							handlers = {
								lsp_zero.default_setup,
								rust_analyzer = lsp_zero.noop(),
								efm = lsp_zero.noop(),
								clangd = lsp_zero.noop(),
								cmake = lsp_zero.noop(),
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
