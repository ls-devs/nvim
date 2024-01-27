return {
  "VonHeikemen/lsp-zero.nvim",
  event = "BufReadPost",
  branch = "v3.x",
  config = require("ls-devs.plugins.lsp.config.lsp_zero"),
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
          opts = require("ls-devs.plugins.lsp.config.lspsaga"),
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
      config = require("ls-devs.plugins.lsp.config.mason_lspconfig"),
      dependencies = {
        {
          -- Formatter
          "nvimtools/none-ls.nvim",
          event = "BufReadPost",
          config = require("ls-devs.plugins.lsp.config.none_ls"),
          dependencies = {
            "jay-babu/mason-null-ls.nvim",
            config = require("ls-devs.plugins.lsp.config.mason_null_ls"),
          },
        },
        {
          "jay-babu/mason-nvim-dap.nvim",
          event = "VeryLazy",
          config = require("ls-devs.plugins.lsp.config.mason_nvim_dap"),
        },
        {
          "williamboman/mason.nvim",
          event = "VeryLazy",
          config = require("ls-devs.plugins.lsp.config.mason"),
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
}
