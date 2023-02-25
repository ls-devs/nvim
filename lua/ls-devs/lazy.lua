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
  -- Lsp & Managers
  {
    "VonHeikemen/lsp-zero.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.lsp-zero").config,
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig", event = "BufReadPre" },
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
  -- Mason & Managers
  {
    cmd = "Mason",
    "williamboman/mason-lspconfig.nvim",
    config = require("ls-devs.plugins.mason-lspconfig").config,
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        config = require("ls-devs.plugins.mason-null-ls").config,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        config = require("ls-devs.plugins.mason-nvim-dap").config,
      },
      {
        "williamboman/mason.nvim",
        config = require("ls-devs.plugins.mason").config,
      },
    },
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "BufReadPre", "CmdlineEnter" },
    config = require("ls-devs.plugins.cmp").config,
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
    name = "catppuccin",
    config = require("ls-devs.plugins.catppuccin").config,
  },
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = { "Neotree", "NeoTreeFloatToggle" },
    keys = require("ls-devs.plugins.neo-tree").keys,
    config = require("ls-devs.plugins.neo-tree").config,
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        config = require("ls-devs.plugins.window-picker").config,
      },
    },
  },
  -- Buffer and status lines
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.lualine").config,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  -- Fidget
  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.fidget").config,
  },
  -- Winbar
  {
    "utilyre/barbecue.nvim",
    version = "*", -- omit this if you only want stable updates ]]
    event = "BufReadPre",
    config = require("ls-devs.plugins.barbecue"),
    dependencies = {
      "neovim/nvim-lspconfig",
      "smiteshp/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  -- Splash screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = require("ls-devs.plugins.alpha").config,
  },
  -- Trouble
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = require("ls-devs.plugins.trouble").config,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- Todos
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPre",
    config = require("ls-devs.plugins.todo-comments").config,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    config = require("ls-devs.plugins.treesitter").config,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "p00f/nvim-ts-rainbow" },
    },
    build = ":TSUpdate",
  },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = require("ls-devs.plugins.telescope"),
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  -- UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.noice").config,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { "MunifTanjim/nui.nvim", event = "VeryLazy" },
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = require("ls-devs.plugins.notify").config,
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.dressing").config,
  },
  -- Formatter
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.null-ls").config,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    ft = { "lua", "python " },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  -- Easy jump
  {
    "ggandor/flit.nvim",
    keys = require("ls-devs.plugins.flit").keys,
    config = require("ls-devs.plugins.flit").config,
    dependencies = {
      "ggandor/leap.nvim",
    },
  },
  -- Http client
  {
    "rest-nvim/rest.nvim",
    keys = require("ls-devs.plugins.rest-nvim").keys,
    config = require("ls-devs.plugins.rest-nvim").config,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Terminal toggle
  {
    "akinsho/toggleterm.nvim",
    keys = require("ls-devs.plugins.toggleterm").keys,
    config = require("ls-devs.plugins.toggleterm").config,
    version = "*",
  },
  -- Auto close pairs
  {
    "windwp/nvim-autopairs",
    event = "BufReadPre",
    config = require("ls-devs.plugins.autopairs").config,
  },
  -- Surround
  {
    "echasnovski/mini.surround",
    keys = require("ls-devs.plugins.surround").keys,
    config = require("ls-devs.plugins.surround").config,
  },
  -- Buffer Remove
  {
    "echasnovski/mini.bufremove",
    keys = require("ls-devs.plugins.bufremove").keys,
  },
  -- Comments
  {
    "echasnovski/mini.comment",
    keys = require("ls-devs.plugins.comment").keys,
    config = require("ls-devs.plugins.comment").config,
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "BufReadPre",
      },
    },
  },
  -- Indent Scope
  {
    "echasnovski/mini.indentscope",
    event = "BufReadPre",
    config = require("ls-devs.plugins.indentscope").config,
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = require("ls-devs.plugins.dapui").keys,
    config = require("ls-devs.plugins.dapui").config,
    dependencies = {
      { "mfussenegger/nvim-dap" },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = require("ls-devs.plugins.nvim-dap-virtual-text").config,
      },
    },
  },
  -- Tmux navigation
  {
    "aserowy/tmux.nvim",
    cond = function()
      if vim.fn.exists("$TMUX") == 0 then
        return false
      else
        return true
      end
    end,
    event = "VeryLazy",
    config = require("ls-devs.plugins.tmux").config,
  },
  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    config = require("ls-devs.plugins.rust-tools"),
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  -- Clang tools
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    config = require("ls-devs.plugins.clang-tools"),
  },
  -- Python
  {
    "luk400/vim-jukit",
    ft = { "python", "ipynb" },
  },
  -- Git
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = require("ls-devs.plugins.lazygit").keys,
  },
  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    config = require("ls-devs.plugins.gitsigns").config,
  },
  {
    "sindrets/diffview.nvim",
    keys = require("ls-devs.plugins.diffview").keys,
    config = require("ls-devs.plugins.diffview").config,
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = require("ls-devs.plugins.vim-fugitive").keys,
  },
  -- Signature
  {
    "ray-x/lsp_signature.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.lsp-signature").config,
  },
  -- Json schemas
  {
    "b0o/schemastore.nvim",
    ft = { "json" },
  },
  -- Inlay hints
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.lsp-inlayhints").config,
  },
  -- Utils
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.indent_blankline").config,
  },
  {
    "abecodes/tabout.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.tabout").config,
  },
  {
    "max397574/better-escape.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.better_escape").config,
  },
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    keys = require("ls-devs.plugins.glow").keys,
    config = require("ls-devs.plugins.glow").config,
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPre",
    config = require("ls-devs.plugins.lastplace").config,
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
    config = require("ls-devs.plugins.silicon"),
    build = "./install.sh build",
  },
}, {
  defaults = {
    lazy = true,
    -- version = "*",
  },
  ui = {
    border = "rounded",
    size = { width = 0.9, height = 0.9 },
    wrap = false,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
  },
  install = {
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "catppuccin" },
  },
  checker = { enabled = true },
})
