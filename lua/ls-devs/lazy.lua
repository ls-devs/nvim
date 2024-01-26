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
        event = "VeryLazy",
        config = require("ls-devs.plugins.mason_lspconfig").config,
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
        config = require("ls-devs.plugins.cmp_npm").config,
        ft = "json",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "tamago324/cmp-zsh",
        config = require("ls-devs.plugins.cmp_zsh").config,
        dependencies = { "Shougo/deol.nvim" },
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
    "zbirenbaum/copilot-cmp",
    config = require("ls-devs.plugins.copilot_cmp").config,
    cmd = "Copilot",
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        config = require("ls-devs.plugins.copilot").config,
      },
    },
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
        event = "VeryLazy",
        config = require("ls-devs.plugins.smart_splits").config,
        build = "./kitty/install-kittens.bash",
      },
    },
  },
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    config = require("ls-devs.plugins.neo_tree").config,
    keys = require("ls-devs.plugins.neo_tree").keys,
    cmd = { "Neotree", "Neotree float" },
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
    event = "BufReadPost",
    config = require("ls-devs.plugins.tabby").config,
    dependencies = "nvim-tree/nvim-web-devicons",
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
    config = require("ls-devs.plugins.windows").config,
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
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
        config = require("ls-devs.plugins.autotag").config,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
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
    config = require("ls-devs.plugins.telescope"),
    cmd = "Telescope",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      { "jonarrien/telescope-cmdline.nvim" },
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
    config = require("ls-devs.plugins.bqf").config,
    ft = "qf",
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
    config = require("ls-devs.plugins.dataviewer").config,
    ft = { "tsv", "csv", "sqlite" },
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
    config = require("ls-devs.plugins.xcodebuild").config,
    ft = "swift",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  -- UrlView
  {
    "axieax/urlview.nvim",
    config = require("ls-devs.plugins.urlview").config,
    cmd = "UrlView",
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
    config = require("ls-devs.plugins.trouble").config,
    cmd = "Trouble",
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
    event = "BufReadPost",
    config = require("ls-devs.plugins.flit").config,
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
    config = require("ls-devs.plugins.coerce").config,
    keys = require("ls-devs.plugins.coerce").keys,
  },
  -- Http client
  {
    "rest-nvim/rest.nvim",
    keys = require("ls-devs.plugins.rest_nvim").keys,
    config = require("ls-devs.plugins.rest_nvim").config,
    ft = "http",
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
    config = require("ls-devs.plugins.mini_surround").config,
    keys = require("ls-devs.plugins.mini_surround").keys,
  },
  -- Buffer Remove
  {
    "echasnovski/mini.bufremove",
    config = require("ls-devs.plugins.mini_bufremove").config,
    keys = require("ls-devs.plugins.mini_bufremove").keys,
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
    config = require("ls-devs.plugins.mini_comment").config,
    keys = require("ls-devs.plugins.mini_comment").keys,
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
    config = require("ls-devs.plugins.dapui").config,
    keys = require("ls-devs.plugins.dapui").keys,
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
    event = "VeryLazy",
    config = require("ls-devs.plugins.tmux").config,
    cond = function()
      if vim.fn.exists("$TMUX") == 0 then
        return false
      else
        return true
      end
    end,
  },
  -- Haskell Tools
  {
    "mrcjkb/haskell-tools.nvim",
    version = "2.x.x", -- recommended
    config = require("ls-devs.plugins.haskell_tools").config,
    ft = { "haskell" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
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
    config = require("ls-devs.plugins.crates").config,
    dependencies = { "nvim-lua/plenary.nvim" },
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
    config = require("ls-devs.plugins.neoai").config,
    keys = require("ls-devs.plugins.neoai").keys,
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
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  -- Aerial
  {
    "stevearc/aerial.nvim",
    config = require("ls-devs.plugins.aerial").config,
    cmd = "AerialToggle",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  -- WinSep
  {
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinNew" },
    config = require("ls-devs.plugins.colorful_winsep").config,
  },
  -- Hbac
  {
    "axkirillov/hbac.nvim",
    event = "BufReadPost",
    config = require("ls-devs.plugins.hbac").config,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
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
    config = require("ls-devs.plugins.typescript_tools").config,
    ft = { "typescript", "typescriptreact", "javascriptreact", "javascript" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  -- WinShift
  {
    "sindrets/winshift.nvim",
    config = require("ls-devs.plugins.winshift").config,
    cmd = { "WinShift" },
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
  -- Github Preview
  {
    "wallpants/github-preview.nvim",
    config = require("ls-devs.plugins.github_preview").config,
    keys = require("ls-devs.plugins.github_preview").keys,
  },
  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    keys = require("ls-devs.plugins.markdown_preview").keys,
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- Glow
  {
    "ellisonleao/glow.nvim",
    config = require("ls-devs.plugins.glow").config,
    keys = require("ls-devs.plugins.glow").keys,
    ft = { "markdown" },
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
    config = require("ls-devs.plugins.silicon").config,
    cmd = "Silicon",
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
