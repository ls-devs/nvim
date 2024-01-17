local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = require("ls-devs.plugins.tokyonight").config,
  },
  -- Lsp & Managers
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    config = require("ls-devs.plugins.lsp-zero").config,
    priority = 900,
    dependencies = {
      -- Inlay hints
      {
        "lvimuser/lsp-inlayhints.nvim",
        config = require("ls-devs.plugins.lsp-inlayhints").config,
      },
      -- Mason & Managers
      {
        "williamboman/mason-lspconfig.nvim",
        config = require("ls-devs.plugins.mason-lspconfig").config,
        event = "VimEnter",
        dependencies = {
          {
            -- Formatter
            "nvimtools/none-ls.nvim",
            event = "BufReadPre",
            config = require("ls-devs.plugins.null-ls").config,
            dependencies = {
              "jay-babu/mason-null-ls.nvim",
              config = require("ls-devs.plugins.mason-null-ls").config,
            },
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
      -- LSP Idle Timeout
      {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
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
    config = require("ls-devs.plugins.cmp").config,
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "FelipeLema/cmp-async-path" },
      { "pontusk/cmp-sass-variables" },
      {
        "jcha0713/cmp-tw2css",
        config = require("ls-devs.plugins.cmp-tw2css").config,
      },
      {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "json",
        config = require("ls-devs.plugins.cmp-npm").config,
      },
      {
        "tamago324/cmp-zsh",
        dependencies = { "Shougo/deol.nvim" },
        config = require("ls-devs.plugins.cmp-zsh").config,
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
  -- Sessions
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    event = "VeryLazy",
    config = require("ls-devs.plugins.possession").config,
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
    config = require("ls-devs.plugins.copilot-cmp").config,
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
    keys = require("ls-devs.plugins.neo-tree").keys,
    config = require("ls-devs.plugins.neo-tree").config,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        config = require("ls-devs.plugins.window-picker").config,
      },
    },
  },
  -- Ranger
  {
    "kevinhwang91/rnvimr",
    cmd = { "RnvimrToggle" },
    config = require("ls-devs.plugins.rnvimr").config,
  },
  -- Buffer and status lines
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
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
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
      {
        "kdheepak/lazygit.nvim",
        keys = require("ls-devs.plugins.lazygit").keys,
      },

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
        dependencies = {
          { "nvim-telescope/telescope.nvim" },
          { "ibhagwan/fzf-lua" },
          {
            "kkharji/sqlite.lua",
          },
        },
        config = require("ls-devs.plugins.neoclip").config,
      },
    },
  },
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
    config = require("ls-devs.plugins.rust-tools").config,
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
    config = require("ls-devs.plugins.cmake_tools").config,
  },

  -- Swift Tools
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = require("ls-devs.plugins.xcodebuild").config,
    ft = "swift",
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
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPre",
    config = require("ls-devs.plugins.todo-comments").config,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.noice").config,
    dependencies = {
      { "MunifTanjim/nui.nvim", event = "VeryLazy" },
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
        config = require("ls-devs.plugins.leap-spooky").config,
      },
    },
  },
  -- Http client
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    keys = require("ls-devs.plugins.rest-nvim").keys,
    config = require("ls-devs.plugins.rest-nvim").config,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Auto close pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = require("ls-devs.plugins.autopairs").config,
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    config = require("ls-devs.plugins.sentiment").config,
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
    config = require("ls-devs.plugins.bufremove").config,
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
  --  Indent Scope
  {
    "echasnovski/mini.indentscope",
    event = "BufReadPost",
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
    enabled = function()
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
    version = "2.x.x",                 -- recommended
  },
  -- Overseer
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun",
      "OverseerToggle",
    },
    dependencies = {
      {
        "akinsho/toggleterm.nvim",
        config = require("ls-devs.plugins.toggleterm").config,
      },
    },
    config = require("ls-devs.plugins.overseer").config,
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
    event = "BufReadPost",
    config = require("ls-devs.plugins.blinker").config,
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
  {
    "lambdalisue/gin.vim",
    cmd = {
      "Gin",
      "GinBuffer",
      "GinBranch",
      "GinCd",
      "GinLcd",
      "GinTcd",
      "GinChaperon",
      "GinDiff",
      "GinEdit",
      "GinLog",
      "GinPatch",
      "GinStatus",
    },
    dependencies = {
      { "vim-denops/denops.vim" },
    },
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = require("ls-devs.plugins.winsep").config,
    event = { "WinNew" },
  },
  {
    "axkirillov/hbac.nvim",
    event = "BufReadPost",
    dependencies = {
      -- these are optional, add them, if you want the telescope module
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = require("ls-devs.plugins.hbac").config,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = require("ls-devs.plugins.gitsigns").config,
  },
  {
    "sindrets/diffview.nvim",
    keys = require("ls-devs.plugins.diffview").keys,
    cmd = {
      "DiffViewOpen",
    },
    config = require("ls-devs.plugins.diffview").config,
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = require("ls-devs.plugins.lazygit").keys,
  },
  -- Ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      { "kevinhwang91/promise-async" },
      {
        "luukvbaal/statuscol.nvim",
        config = require("ls-devs.plugins.statuscol").config,
      },
    },
    event = "BufRead",
    config = require("ls-devs.plugins.ufo").config,
  },
  -- Presence
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    config = require("ls-devs.plugins.presence").config,
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
    config = require("ls-devs.plugins.typescript-tools").config,
  },
  {
    "sindrets/winshift.nvim",
    cmd = { "WinShift" },
    config = require("ls-devs.plugins.winshift").config,
  },
  -- Live Server
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm i -g live-server",
    cmd = "LiveServerStart",
    config = require("ls-devs.plugins.live-server").config,
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
    cmd = "Glow",
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
  {
    "timtro/glslView-nvim",
    ft = "glsl",
    config = require("ls-devs.plugins.glslViewer").config,
    keys = require("ls-devs.plugins.glslViewer").keys,
  },
  {
    "jokajak/keyseer.nvim",
    version = "*",
    cmd = "KeySeer",
    config = require("ls-devs.plugins.keyseer").config,
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
