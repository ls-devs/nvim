local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = require("ls-devs.plugins.tokyonight").config,
  },
  -- Lsp & Managers
  {
    "VonHeikemen/lsp-zero.nvim",
    event = "BufReadPost",
    branch = "v3.x",
    config = require("ls-devs.plugins.lsp_zero").config,
    dependencies = {
      -- LSP
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPost",
        dependencies = {
          -- LSP Enhancement
          {
            "glepnir/lspsaga.nvim",
            event = "LspAttach",
            config = require("ls-devs.plugins.lsp_saga").config,
            dependencies = {
              { "nvim-tree/nvim-web-devicons" },
              { "nvim-treesitter/nvim-treesitter" },
            },
          },
        },
      },
      -- Mason & Managers
      {
        "williamboman/mason-lspconfig.nvim",
        config = require("ls-devs.plugins.mason_lspconfig").config,
        event = "VeryLazy",
        dependencies = {
          {
            -- Formatter
            "nvimtools/none-ls.nvim",
            event = "BufReadPost",
            config = require("ls-devs.plugins.none_ls").config,
            dependencies = {
              "jay-babu/mason-null-ls.nvim",
              config = require("ls-devs.plugins.mason_null_ls").config,
            },
          },
          {
            "jay-babu/mason-nvim-dap.nvim",
            event = "VeryLazy",
            config = require("ls-devs.plugins.mason_nvim_dap").config,
          },
          {
            "williamboman/mason.nvim",
            event = "VeryLazy",
            config = require("ls-devs.plugins.mason").config,
          },
        },
      },
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        event = "InsertEnter",
      },
    },
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "BufReadPre", "CmdlineEnter" },
    config = require("ls-devs.plugins.nvim_cmp").config,
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "FelipeLema/cmp-async-path" },
      { "pontusk/cmp-sass-variables" },
      {
        "jcha0713/cmp-tw2css",
        config = require("ls-devs.plugins.cmp_tw2css").config,
      },
      {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "json",
        config = require("ls-devs.plugins.cmp_npm").config,
      },
      {
        "tamago324/cmp-zsh",
        dependencies = { "Shougo/deol.nvim" },
        config = require("ls-devs.plugins.cmp_zsh").config,
      },
      { "lukas-reineke/cmp-rg" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "onsails/lspkind.nvim" },
      { "SergioRibera/cmp-dotenv" },
      -- Snippet Collection (Optional)
      {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
      },
    },
  },
  -- Copilot
  {
    cmd = "Copilot",
    "zbirenbaum/copilot-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        config = require("ls-devs.plugins.copilot").config,
      },
    },
    config = require("ls-devs.plugins.copilot_cmp").config,
  },
  -- Mapping
  {
    "mrjones2014/legendary.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.legendary").config,
    dependencies = {
      {
        "kkharji/sqlite.lua",
        event = "VeryLazy",
      },
      -- Smart Splits
      {
        "mrjones2014/smart-splits.nvim",
        build = "./kitty/install-kittens.bash",
        event = "VeryLazy",
        config = require("ls-devs.plugins.smart_splits").config,
      },
    },
  },
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = { "Neotree", "Neotree float" },
    keys = require("ls-devs.plugins.neo_tree").keys,
    config = require("ls-devs.plugins.neo_tree").config,
    branch = "v3.x",
    dependencies = {
      "3rd/image.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        config = require("ls-devs.plugins.window_picker").config,
      },
    },
  },
  -- Tabby
  {
    "nanozuki/tabby.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "BufReadPost",
    config = require("ls-devs.plugins.tabby").config,
  },
  -- Status lines
  {
    "nvim-lualine/lualine.nvim",
    event = "BufReadPost",
    config = require("ls-devs.plugins.lualine").config,
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
      },
    },
  },
  -- Splash screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = require("ls-devs.plugins.alpha").config,
  },
  -- Windows
  {
    "anuvyklack/windows.nvim",
    event = "BufReadPost",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = require("ls-devs.plugins.windows").config,
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost",
    config = require("ls-devs.plugins.treesitter").config,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "tree-sitter/tree-sitter-cpp" },
      -- Auto Tag
      {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = require("ls-devs.plugins.autotag").config,
      },

      {
        "HiPhish/rainbow-delimiters.nvim",
        config = require("ls-devs.plugins.rainbow_delimiter").config,
      },
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
      {
        "benfowler/telescope-luasnip.nvim",
      },
      { "nvim-telescope/telescope-media-files.nvim" },
      { "xiyaowong/telescope-emoji.nvim" },
      {
        "AckslD/nvim-neoclip.lua",
        config = require("ls-devs.plugins.neoclip").config,
        dependencies = {
          { "nvim-telescope/telescope.nvim" },
          { "ibhagwan/fzf-lua" },
          {
            "kkharji/sqlite.lua",
          },
        },
      },
    },
  },
  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = require("ls-devs.plugins.bqf").config,
    dependencies = {
      "junegunn/fzf",
      build = function()
        vim.fn["fzf#install"]()
      end,
    },
  },
  -- NeoComposer
  {
    "ecthelionvi/NeoComposer.nvim",
    event = "BufReadPost",
    config = require("ls-devs.plugins.neocomposer").config,
    dependencies = { "kkharji/sqlite.lua" },
  },
  -- Muren
  {
    "AckslD/muren.nvim",
    config = require("ls-devs.plugins.muren").config,
    cmd = {
      "MurenToggle",
      "MurenOpen",
      "MurenClose",
      "MurenFresh",
      "MurenUnique",
    },
  },
  -- Data Viewer
  {
    "vidocqh/data-viewer.nvim",
    ft = { "tsv", "csv", "sqlite" },
    config = require("ls-devs.plugins.dataviewer").config,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    },
  },
  -- Rust tools
  {
    "simrat39/rust-tools.nvim",
    event = { "BufReadPost *.rs" },
    config = require("ls-devs.plugins.rust_tools").config,
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  -- Clangd tools
  {
    "p00f/clangd_extensions.nvim",
    event = { "BufReadPost *.cpp *.c" },
    config = require("ls-devs.plugins.clangd_extensions").config,
    ft = { "c", "cpp" },
  },
  -- Cmake Tools
  {
    "Civitasv/cmake-tools.nvim",
    config = require("ls-devs.plugins.cmake_tools").config,
    cmd = {
      "CMakeBuild",
      "CMakeRun",
      "CMakeQuickRun",
      "CMakeSelectBuildPreset",
      "CMakeSelectBuildTarget",
      "CMakeSelectConfigurePreset",
      "CMakeSelectBuildType",
      "CMakeSelectKit",
      "CMakeSelectLaunchTarget",
      "CMakeQuickDebug",
      "CMakeOpen",
      "CMakeClose",
      "CMakeClean",
      "CMakeQuickBuild",
      "CMakeDebug",
      "CMakeInstall",
      "CMakeGenerate",
      "CMakeLaunchArgs",
      "CMakeStop",
    },
  },
  -- Swift Tools
  {
    "wojciech-kulik/xcodebuild.nvim",
    ft = "swift",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = require("ls-devs.plugins.xcodebuild").config,
  },
  -- UrlView
  {
    "axieax/urlview.nvim",
    cmd = "UrlView",
    config = require("ls-devs.plugins.urlview").config,
  },
  -- Fidget
  {
    "j-hui/fidget.nvim",
    branch = "legacy",
    event = "BufReadPost",
    config = require("ls-devs.plugins.fidget").config,
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
    event = "BufReadPre",
    config = require("ls-devs.plugins.todo_comments").config,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- Noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.noice").config,
    dependencies = {
      { "MunifTanjim/nui.nvim", event = "VeryLazy" },
      {
        "rcarriga/nvim-notify",
        event = "BufReadPost",
        config = require("ls-devs.plugins.notify").config,
      },
    },
  },
  -- Dressing
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.dressing").config,
  },
  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    ft = { "lua", "python", "typescript", "typescriptreact", "javascript", "javascriptreact", "php", "c", "cpp" },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  -- Easy jump
  {
    "ggandor/flit.nvim",
    config = require("ls-devs.plugins.flit").config,
    event = "BufReadPost",
    dependencies = {
      {
        "ggandor/leap.nvim",
        config = require("ls-devs.plugins.leap").config,
      },
      {
        "ggandor/leap-spooky.nvim",
        config = require("ls-devs.plugins.leap_spooky").config,
      },
    },
  },
  -- Coerce
  {
    "gregorias/coerce.nvim",
    tag = "v0.1.1",
    keys = require("ls-devs.plugins.coerce").keys,
    config = require("ls-devs.plugins.coerce").config,
  },
  -- Http client
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = require("ls-devs.plugins.rest_nvim").keys,
    config = require("ls-devs.plugins.rest_nvim").config,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Auto close pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = require("ls-devs.plugins.autopairs").config,
  },
  -- Sentiment
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    config = require("ls-devs.plugins.sentiment").config,
  },
  -- Surround
  {
    "echasnovski/mini.surround",
    keys = require("ls-devs.plugins.mini_surround").keys,
    config = require("ls-devs.plugins.mini_surround").config,
  },
  -- Buffer Remove
  {
    "echasnovski/mini.bufremove",
    keys = require("ls-devs.plugins.mini_bufremove").keys,
    config = require("ls-devs.plugins.mini_bufremove").config,
  },
  -- Lock Buffers
  {
    "stevearc/stickybuf.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.stickybuf").config,
  },
  -- Comments
  {
    "echasnovski/mini.comment",
    keys = require("ls-devs.plugins.mini_comment").keys,
    config = require("ls-devs.plugins.mini_comment").config,
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = require("ls-devs.plugins.nvim_ts_context_comment_string").config,
      },
    },
  },
  -- Chainsaw
  {
    "chrisgrieser/nvim-chainsaw",
    config = require("ls-devs.plugins.chainsaw").config,
    keys = require("ls-devs.plugins.chainsaw").keys,
  },
  --  Indent Scope
  {
    "echasnovski/mini.indentscope",
    event = "BufReadPost",
    config = require("ls-devs.plugins.mini_indentscope").config,
  },
  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    keys = require("ls-devs.plugins.dapui").keys,
    config = require("ls-devs.plugins.dapui").config,
    dependencies = {
      { "mfussenegger/nvim-dap" },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = require("ls-devs.plugins.nvim_dap_virtual_text").config,
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
  -- Haskell Tools
  {
    "mrcjkb/haskell-tools.nvim",
    ft = { "haskell" },
    config = require("ls-devs.plugins.haskell_tools").config,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    version = "2.x.x",              -- recommended
  },
  -- Overseer
  {
    "stevearc/overseer.nvim",
    config = require("ls-devs.plugins.overseer").config,
    keys = require("ls-devs.plugins.overseer").keys,
    dependencies = {
      {
        "akinsho/toggleterm.nvim",
        config = require("ls-devs.plugins.toggleterm").config,
        keys = require("ls-devs.plugins.toggleterm").keys,
      },
    },
  },
  -- Crates.io
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = require("ls-devs.plugins.crates").config,
  },
  -- Blink
  {
    "Grazfather/blinker.nvim",
    config = require("ls-devs.plugins.blinker").config,
    keys = require("ls-devs.plugins.blinker").keys,
  },
  -- Python
  {
    "luk400/vim-jukit",
    ft = { "python", "ipynb" },
  },
  -- NeoAI
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = require("ls-devs.plugins.neoai").keys,
    config = require("ls-devs.plugins.neoai").config,
  },
  -- Aerial
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    config = require("ls-devs.plugins.aerial").config,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- WinSep
  {
    "nvim-zh/colorful-winsep.nvim",
    config = require("ls-devs.plugins.colorful_winsep").config,
    event = { "WinNew" },
  },
  -- Hbac
  {
    "axkirillov/hbac.nvim",
    event = "BufReadPost",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = require("ls-devs.plugins.hbac").config,
  },
  -- Git Blame
  {
    "f-person/git-blame.nvim",
    event = "BufReadPost",
    config = require("ls-devs.plugins.git-blame").config,
    cond = function()
      return vim.fn.isdirectory(".git") == 1
    end,
  },
  -- DiffView
  {
    "sindrets/diffview.nvim",
    config = require("ls-devs.plugins.diffview").config,
    keys = require("ls-devs.plugins.diffview").keys,
    cond = function()
      return vim.fn.isdirectory(".git") == 1
    end,
  },
  -- Ufo
  {
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    config = require("ls-devs.plugins.ufo").config,
    dependencies = {
      { "kevinhwang91/promise-async" },
      {
        "luukvbaal/statuscol.nvim",
        config = require("ls-devs.plugins.statuscol").config,
      },
    },
  },
  -- Json schemas
  {
    "b0o/schemastore.nvim",
    ft = { "json" },
  },
  -- Typescript
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascriptreact", "javascript" },
    config = require("ls-devs.plugins.typescript_tools").config,
  },
  -- WinShift
  {
    "sindrets/winshift.nvim",
    cmd = { "WinShift" },
    config = require("ls-devs.plugins.winshift").config,
  },
  -- Live Server
  {
    "barrett-ruth/live-server.nvim",
    config = require("ls-devs.plugins.live_server").config,
    cmd = "LiveServerStart",
    build = "pnpm i -g live-server",
  },
  -- Tabout
  {
    "abecodes/tabout.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.tabout").config,
  },
  -- Better Escape
  {
    "max397574/better-escape.nvim",
    event = "BufReadPre",
    config = require("ls-devs.plugins.better_escape").config,
  },
  -- Glow
  {
    "ellisonleao/glow.nvim",
    keys = require("ls-devs.plugins.glow").keys,
    config = require("ls-devs.plugins.glow").config,
    cmd = "Glow",
  },
  -- Lastplace
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPre",
    config = require("ls-devs.plugins.lastplace").config,
  },
  -- Colorizer
  {
    "chrisbra/Colorizer",
    cmd = "ColorToggle",
  },
  -- Screenshot
  {
    "krivahtoo/silicon.nvim",
    cmd = "Silicon",
    config = require("ls-devs.plugins.silicon").config,
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
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "󰄳 ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = true,
  },
  readme = {
    enabled = true,
  },
})
