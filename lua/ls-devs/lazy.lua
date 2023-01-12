local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/plugins.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Lsp & Managers
  {
    "VonHeikemen/lsp-zero.nvim",
    config = require("ls-devs.plugins.lsp").config,
    event = "BufReadPre",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig", event = "BufReadPre" },
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = require("ls-devs.plugins.mason").config,
        dependencies = {
          {
            "williamboman/mason-lspconfig.nvim",
            config = require("ls-devs.plugins.mason-lspconfig").config,
          },
          {
            "jay-babu/mason-null-ls.nvim",
            config = require("ls-devs.plugins.mason-null-ls").config,
          },
          {
            "jay-babu/mason-nvim-dap.nvim",
            config = require("ls-devs.plugins.mason-nvim-dap").config,
            dependencies = {
              { "mfussenegger/nvim-dap" },
            },
          },
        },
      },
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
    config = require("ls-devs.plugins.cmp").config,
    event = { "InsertEnter", "BufReadPre", "CmdlineEnter" },
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
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    config = require("ls-devs.plugins.lualine").config,
    event = "VeryLazy",
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
    branch = "dev", -- omit this if you only want stable updates ]]
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
    config = require("ls-devs.plugins.alpha").config,
    event = "VimEnter",
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    config = require("ls-devs.plugins.trouble").config,
  },

  -- Todos
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPre",
    config = require("ls-devs.plugins.todo-comments").config,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "p00f/nvim-ts-rainbow" },
    },
    config = require("ls-devs.plugins.treesitter").config,
    build = ":TSUpdate",
    event = "BufReadPre",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = require("ls-devs.plugins.telescope"),
    dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
  },

  -- UI
  {
    "stevearc/dressing.nvim",
    config = require("ls-devs.plugins.dressing").config,
    event = "VeryLazy",
  },

  -- Formatter
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = require("ls-devs.plugins.null-ls").config,
    event = "BufReadPre",
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
    "ggandor/leap.nvim",
    config = require("ls-devs.plugins.leap").config,
    keys = require("ls-devs.plugins.leap").keys,
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = require("ls-devs.plugins.hop").keys,
    config = require("ls-devs.plugins.hop").config,
  },

  -- Http client
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = require("ls-devs.plugins.rest-nvim").keys,
    config = require("ls-devs.plugins.rest-nvim").config,
  },

  -- Terminal toggle
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = require("ls-devs.plugins.toggleterm").keys,
    config = require("ls-devs.plugins.toggleterm").config,
  },

  -- Auto close pairs
  {
    "windwp/nvim-autopairs",
    config = require("ls-devs.plugins.autopairs").config,
    event = "BufReadPre",
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
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "BufReadPre",
      },
    },
    config = require("ls-devs.plugins.comment").config,
    keys = require("ls-devs.plugins.comment").keys,
  },

  -- Indent Scope
  {
    "echasnovski/mini.indentscope",
    config = require("ls-devs.plugins.indentscope").config,
    event = "BufReadPre",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      { "mfussenegger/nvim-dap" },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = require("ls-devs.plugins.nvim-dap-virtual-text").config,
      },
    },
    keys = require("ls-devs.plugins.dapui"),
    config = require("ls-devs.plugins.dapui").config,
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
    config = require("ls-devs.plugins.tmux").config,
    event = "VeryLazy",
  },

  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    config = require("ls-devs.plugins.rust-tools"),
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
    config = require("ls-devs.plugins.lsp-signature").config,
    event = "BufReadPre",
  },
  {
    "b0o/schemastore.nvim",
    ft = { "json" },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = require("ls-devs.plugins.lsp-inlayhints").config,
    event = "BufReadPre",
  },

  -- Utils
  {
    "lukas-reineke/indent-blankline.nvim",
    config = require("ls-devs.plugins.indent_blankline").config,
    event = "BufReadPre",
  },
  {
    "abecodes/tabout.nvim",
    config = require("ls-devs.plugins.tabout").config,
    event = "BufReadPre",
  },
  {
    "max397574/better-escape.nvim",
    config = require("ls-devs.plugins.better_escape").config,
    event = "BufReadPre",
  },
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    keys = require("ls-devs.plugins.glow").keys,
    config = require("ls-devs.plugins.glow").config,
  },
  {
    "rcarriga/nvim-notify",
    config = require("ls-devs.plugins.notify").config,
    event = "VeryLazy",
  },
  {
    "ethanholz/nvim-lastplace",
    config = require("ls-devs.plugins.lastplace").config,
    event = "BufReadPre",
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
