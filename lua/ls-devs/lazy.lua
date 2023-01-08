local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Lsp & Dap Managers
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "jayp0521/mason-nvim-dap.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "onsails/lspkind.nvim" },

			-- Snippets
			{ "L3MON4D3/LuaSnip", version = "v1.*" },
			-- Snippet Collection (Optional)
			{ "rafamadriz/friendly-snippets" },
		},
	},
	-- Colorscheme
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catpuccin",
	},
	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
	},

	-- Buffer and status lines
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	-- Fidget
	{
		"j-hui/fidget.nvim",
	},
	-- Barbecue
	{
		"utilyre/barbecue.nvim",
		branch = "dev", -- omit this if you only want stable updates ]]
		dependencies = {
			"neovim/nvim-lspconfig",
			"smiteshp/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
	},
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{ "p00f/nvim-ts-rainbow" },
		},
		build = ":TSUpdate",
	},
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	-- UI
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	--Formatter
	{ "jose-elias-alvarez/null-ls.nvim" },
	{ "jayp0521/mason-null-ls.nvim" },
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
	},
	ft = { "lua", "python " },
	-- Easy jump
	{ "phaazon/hop.nvim", branch = "v2" },
	-- Http client
	{
		"rest-nvim/rest.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
		keys = {
			{ "<leader>rh", "<Plug>RestVim", "Toggle RestVim" },
		},
	},
	-- Terminal toggle
	{ "akinsho/toggleterm.nvim", version = "*" },
	-- Auto close pairs
	{ "windwp/nvim-autopairs" },
	-- Surround
	{ "kylechui/nvim-surround" },
	-- Comments
	{ "numToStr/Comment.nvim" },
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	-- Debugger
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "theHamsta/nvim-dap-virtual-text" },
	-- Rust tools
	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		config = function()
			local rt = require("rust-tools")
			local extension_path = vim.env.HOME .. "/.vscode-insiders/extensions/vadimcn.vscode-lldb-1.8.1/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
			rt.setup({
				tools = {
					runnables = {
						use_telescope = true,
					},
					inlay_hints = { auto = true, show_parameter_hints = true, locationLinks = false },
					hover_actions = { auto_focus = true },
				},
				dap = {
					adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
				},

				server = {

					on_attach = function(_, bufnr)
						vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
						vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
						local opts = { noremap = true, silent = true }
						local keymap = vim.api.nvim_buf_set_keymap
						keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
						keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
						keymap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
						keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
						keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
						keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
						keymap(bufnr, "n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
						keymap(bufnr, "n", "<leader>do", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
						keymap(bufnr, "n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
						keymap(bufnr, "n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
						keymap(bufnr, "n", "<leader>uo", "<cmd>lua require('dapui').toggle()<CR>", opts)
						keymap(bufnr, "n", "<leader>uc", "<cmd>lua require('dapui').close()<CR>", opts)
						keymap(bufnr, "n", "<leader>un", ":DapContinue<CR>", opts)
						keymap(bufnr, "n", "<leader>ut", ":DapTerminate<CR>", opts)
						keymap(bufnr, "n", "<leader>bb", ":DapToggleBreakpoint<CR>", opts)
					end,
					["rust-analyzer"] = {
						inlayHints = { auto = true, show_parameter_hints = true, locationLinks = false },
						lens = {
							enable = true,
						},
						checkonsave = {
							command = "clippy",
						},
					},
				},
			})
		end,
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	-- Python
	{ "luk400/vim-jukit", ft = { "python", "ipynb" } },
	-- Git
	{ "lewis6991/gitsigns.nvim" },
	{ "sindrets/diffview.nvim", keys = {
		{ "<leader>dvo", "<cmd>DiffviewOpen<CR>", "DiffviewOpen" },
	} },
	{ "tpope/vim-fugitive" },
	-- LSP
	{ "ray-x/lsp_signature.nvim" },
	{ "b0o/schemastore.nvim", ft = { "json" } },
	{ "lvimuser/lsp-inlayhints.nvim" },
	-- Utils
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "abecodes/tabout.nvim" },
	{ "max397574/better-escape.nvim" },
	{
		"ellisonleao/glow.nvim",
		ft = "markdown",
		config = function()
			require("glow").setup({
				border = "rounded", -- floating window border config
				style = "dark",
			})
		end,
	},
	{ "rcarriga/nvim-notify" },
	{ "ethanholz/nvim-lastplace" },
	{ "dstein64/vim-startuptime" },
	{ "chrisbra/Colorizer" },
	-- Screenshot
	{ "krivahtoo/silicon.nvim", build = "./install.sh build" },
}, {
	lazy = true,
	version = "*",

	ui = {
		border = "rounded",
	},
	install = {
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "catppuccin" },
	},
})
