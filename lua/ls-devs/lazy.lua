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
    config = require("ls-devs.lazy.lsp").config,
    event = "BufReadPost",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig", event = "BufReadPre" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        version = "v1.*",
        event = "InsertEnter",
      },
      -- Snippet Collection (Optional)
      {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
      },
    },
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    config = require("ls-devs.lazy.cmp").config,
    event = { "InsertEnter", "BufReadPost", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "onsails/lspkind.nvim" },
    },
  },

  -- Colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catpuccin",
    config = require("ls-devs.lazy.catppuccin").config,
  },
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = require("ls-devs.lazy.neo-tree").keys,
    config = require("ls-devs.lazy.neo-tree").config,
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        config = require("ls-devs.lazy.window-picker").config,
      },
    },
  },

  -- Buffer and status lines
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = require("ls-devs.lazy.lualine").config,
    event = "VeryLazy",
  },
  -- Fidget
  {
    "j-hui/fidget.nvim",
    event = "BufReadPost",
    config = require("ls-devs.lazy.fidget").config,
  },
  -- Barbecue
  {
    "utilyre/barbecue.nvim",
    branch = "dev", -- omit this if you only want stable updates ]]
    event = "BufReadPost",
    config = require("ls-devs.lazy.barbecue"),
    dependencies = {
      "neovim/nvim-lspconfig",
      "smiteshp/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  -- Splash screen
  {
    "goolord/alpha-nvim",
    config = require("ls-devs.lazy.alpha").config,
    event = "VimEnter",
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "p00f/nvim-ts-rainbow" },
    },
    config = require("ls-devs.lazy.treesitter").config,
    build = ":TSUpdate",
    event = "BufReadPost",
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = require("ls-devs.lazy.telescope"),
    dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
  },
  -- UI
  {
    "stevearc/dressing.nvim",
    config = require("ls-devs.lazy.dressing").config,
    event = "VeryLazy",
  },
  --Formatter
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = require("ls-devs.lazy.null-ls").config,
    event = "BufReadPre",
  },
  {
    "jayp0521/mason-null-ls.nvim",
    cmd = "Mason",
    config = require("ls-devs.lazy.mason-null-ls").config,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    ft = { "lua", "python " },
  },
  -- Easy jump
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = require("ls-devs.lazy.hop").keys,
    config = require("ls-devs.lazy.hop").config,
  },
  -- Http client
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = require("ls-devs.lazy.rest-nvim").keys,
    config = require("ls-devs.lazy.rest-nvim").config,
  },
  -- Terminal toggle
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = require("ls-devs.lazy.toggleterm").keys,
    config = require("ls-devs.lazy.toggleterm").config,
  },
  -- Auto close pairs
  {
    "windwp/nvim-autopairs",
    config = require("ls-devs.lazy.autopairs").config,
    event = "BufReadPost",
  },
  -- Surround
  {
    "kylechui/nvim-surround",
    config = require("ls-devs.lazy.nvim-surround").config,
    event = "BufReadPost",
  },
  -- Comments
  {
    "numToStr/Comment.nvim",
    config = require("ls-devs.lazy.comment").config,
    event = "BufReadPost",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPost",
  },
  -- Debugger
  {
    "jayp0521/mason-nvim-dap.nvim",
    cmd = "Mason",
    config = require("ls-devs.lazy.mason-nvim-dap"),
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "theHamsta/nvim-dap-virtual-text",
        config = require("ls-devs.lazy.nvim-dap-virtual-text").config,
      },
    },
    keys = require("ls-devs.lazy.dapui"),
    config = require("ls-devs.lazy.dapui").config,
  },
  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    config = require("ls-devs.lazy.rust-tools"),
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  -- Python
  {
    "luk400/vim-jukit",
    ft = { "python", "ipynb" },
  },
  -- Git
  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    config = require("ls-devs.lazy.gitsigns").config,
  },
  {
    "sindrets/diffview.nvim",
    keys = require("ls-devs.lazy.diffview").keys,
    config = require("ls-devs.lazy.diffview").config,
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = require("ls-devs.lazy.vim-fugitive").keys,
  },
  -- LSP
  {
    "ray-x/lsp_signature.nvim",
    config = require("ls-devs.lazy.lsp-signature").config,
    event = "BufReadPost",
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json" },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = require("ls-devs.lazy.lsp-inlayhints").config,
    event = "BufReadPost",
  },
  -- Utils
  {
    "lukas-reineke/indent-blankline.nvim",
    config = require("ls-devs.lazy.indent_blankline").config,
    event = "BufReadPre",
  },
  {
    "abecodes/tabout.nvim",
    config = require("ls-devs.lazy.tabout").config,
    event = "BufReadPost",
  },
  {
    "max397574/better-escape.nvim",
    config = require("ls-devs.lazy.better_escape").config,
    event = "BufReadPost",
  },
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    keys = require("ls-devs.lazy.glow").keys,
    config = require("ls-devs.lazy.glow").config,
  },
  {
    "rcarriga/nvim-notify",
    config = require("ls-devs.lazy.notify").config,
    event = "VeryLazy",
  },
  {
    "ethanholz/nvim-lastplace",
    config = require("ls-devs.lazy.lastplace").config,
    event = "BufReadPost",
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
  {
    "chrisbra/Colorizer",
    cmd = "ColorToggle",
  },
  -- Screenshot
  {
    "krivahtoo/silicon.nvim",
    cmd = "Silicon",
    config = require("ls-devs.lazy.silicon"),
    build = "./install.sh build",
  },
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
