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
	use("williamboman/mason.nvim")
	use({ "jayp0521/mason-nvim-dap.nvim" })
	use("williamboman/mason-lspconfig.nvim")

	-- Colorscheme
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- File explorer
	use({ "kyazdani42/nvim-tree.lua", requires = { { "kyazdani42/nvim-web-devicons" } }, tag = "nightly" })

	-- Buffer and status lines
	use({ "nvim-lualine/lualine.nvim", requires = { { "nvim-tree/nvim-web-devicons" } } })

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
	-- Telescope show medias
	use({
		"HendrikPetertje/telescope-media-files.nvim",
		branch = "fix-replace-ueber-with-viu",
		requires = { { "nvim-lua/popup.nvim" } },
	})

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

	-- Auto-save
	use("Pocco81/auto-save.nvim")

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
	use({ "luk400/vim-jukit", ft = { "python" } })

	-- Clang extensions
	use("p00f/clangd_extensions.nvim")

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("sindrets/diffview.nvim")
	use("tpope/vim-fugitive")

	-- Completion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("onsails/lspkind.nvim")

	-- LSP
	use("neovim/nvim-lspconfig")
	use({ "b0o/schemastore.nvim", ft = { "json" } })
	use("jose-elias-alvarez/typescript.nvim")
	use("ray-x/lsp_signature.nvim")
	use("lvimuser/lsp-inlayhints.nvim")

	-- Utils
	use("goolord/alpha-nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("abecodes/tabout.nvim")
	use("max397574/better-escape.nvim")
	use({ "ellisonleao/glow.nvim", ft = { "md" } })
	use("sitiom/nvim-numbertoggle")
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
