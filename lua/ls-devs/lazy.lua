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
      { "neovim/nvim-lspconfig", event = "BufReadPre" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jayp0521/mason-nvim-dap.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp", event = "InsertEnter" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "onsails/lspkind.nvim" },

      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        version = "v1.*",
      },
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
    event = "VeryLazy",
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
    event = "BufReadPost",
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = require("ls-devs.lazyconf.telescope"),
    dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
  },
  -- UI
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  --Formatter
  { "jose-elias-alvarez/null-ls.nvim", event = "BufReadPre" },
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
      { "<leader>rh", "<Plug>RestVim", desc = "Toggle RestVim" },
    },
  },
  -- Terminal toggle
  { "akinsho/toggleterm.nvim", version = "*" },
  -- Auto close pairs
  { "windwp/nvim-autopairs" },
  -- Surround
  { "kylechui/nvim-surround" },
  -- Comments
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  -- Debugger
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  { "theHamsta/nvim-dap-virtual-text" },
  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    config = require("ls-devs.lazyconf.rust-tools"),

    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  -- Python
  { "luk400/vim-jukit", ft = { "python", "ipynb" } },
  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "sindrets/diffview.nvim", keys = {
    { "<leader>dvo", "<cmd>DiffviewOpen<CR>", desc = "DiffviewOpen" },
  } },
  { "tpope/vim-fugitive" },
  -- LSP
  { "ray-x/lsp_signature.nvim" },
  { "b0o/schemastore.nvim", ft = { "json" } },
  { "lvimuser/lsp-inlayhints.nvim" },
  -- Utils
  { "lukas-reineke/indent-blankline.nvim", event = "BufReadPre" },
  { "abecodes/tabout.nvim" },
  { "max397574/better-escape.nvim" },
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    config = require("ls-devs.lazyconf.glow"),
  },
  { "rcarriga/nvim-notify" },
  { "ethanholz/nvim-lastplace" },
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
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
