local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	--luacheck: ignore PACKER_BOOTSTRAP
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the packer.lua file
vim.cmd([[
 augroup packer_user_config
 autocmd!
 autocmd BufWritePost packer.lua source <afile> | PackerSync
 augroup end
 ]])

local packer = require("packer")

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	-- Performance
	use("lewis6991/impatient.nvim")

	-- Lsp & Dap Managers
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
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
			{ "L3MON4D3/LuaSnip", tag = "v1.*" },
			-- Snippet Collection (Optional)
			{ "rafamadriz/friendly-snippets" },
		},
	})
	--
	-- Colorscheme
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- File explorer
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker",
		},
	})
	-- Buffer and status lines
	use({ "nvim-lualine/lualine.nvim", requires = { { "nvim-tree/nvim-web-devicons" } } })

	-- Fidget
	use("j-hui/fidget.nvim")

	use({
		"utilyre/barbecue.nvim",
		branch = "dev", -- omit this if you only want stable updates ]]
		requires = {
			"neovim/nvim-lspconfig",
			"smiteshp/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		after = { "catppuccin", "nvim-web-devicons" }, -- keep this if you're using NvChad
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			{ "windwp/nvim-ts-autotag" },
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{ "p00f/nvim-ts-rainbow" },
		},
		run = ":TSUpdate",
	})

	-- Telescope
	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- UI
	use("stevearc/dressing.nvim")

	--Formatter
	use("jayp0521/mason-null-ls.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		ft = { "lua", "python " },
	})

	-- Easy jump
	use({ "phaazon/hop.nvim", branch = "v2" })

	-- Http client
	use({ "rest-nvim/rest.nvim", requires = { { "nvim-lua/plenary.nvim" } } })

	-- Terminal toggle
	use({ "akinsho/toggleterm.nvim", tag = "*" })

	-- Auto close pairs
	use("windwp/nvim-autopairs")

	-- Surround
	use("kylechui/nvim-surround")

	-- Comments
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Debugger
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("theHamsta/nvim-dap-virtual-text")

	-- Rust tools
	use({
		"simrat39/rust-tools.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Python
	use({ "luk400/vim-jukit" })

	-- Clang extensions
	use("p00f/clangd_extensions.nvim")

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("sindrets/diffview.nvim")
	use("tpope/vim-fugitive")

	-- LSP
	use({ "ray-x/lsp_signature.nvim" })
	use({ "b0o/schemastore.nvim", ft = { "json" } })
	use("lvimuser/lsp-inlayhints.nvim")

	-- Utils
	use("lukas-reineke/indent-blankline.nvim")
	use("abecodes/tabout.nvim")
	use("max397574/better-escape.nvim")
	use({ "ellisonleao/glow.nvim" })
	use("rcarriga/nvim-notify")
	use("ethanholz/nvim-lastplace")
	use("dstein64/vim-startuptime")
	use("chrisbra/Colorizer")

	-- Screenshot
	use({ "krivahtoo/silicon.nvim", run = "./install.sh build" })

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
