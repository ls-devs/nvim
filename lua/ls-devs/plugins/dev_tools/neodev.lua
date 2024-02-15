return {
	"folke/neodev.nvim",
	ft = "lua",
	opts = {
		library = {
			enabled = true,
			runtime = true,
			types = true,
			plugins = {
				"lazy.nvim",
				"mason.nvim",
				"mason-lspconfig.nvim",
				"mason-tool-installer.nvim",
				"nvim-lspconfig",
				"lspsaga.nvim",
				"nvim-treesitter",
				"nvim-cmp",
				"cmp-nvim-lsp",
				"conform.nvim",
				"nvim-lint",
				"noice.nvim",
				"neo-tree.nvim",
				"telescope.nvim",
				"legendary.nvim",
				"toggleterm.nvim",
				"catppuccin",
				"plenary.nvim",
				"neodev.nvim",
				"neotest",
				"fidget.nvim",
				"alpha-nvim",
				"nvim-web-devicons",
				"lualine.nvim",
			},
		},
		setup_jsonls = true,
		override = function(root_dir, options) end,
		lspconfig = true,
		pathStrict = true,
	},
	config = function(_, opts)
		require("neodev").setup(opts)
		require("lspconfig")["lua_ls"].setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
	end,
}
