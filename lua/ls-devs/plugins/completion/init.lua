return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "BufReadPre", "CmdlineEnter" },
    config = require("ls-devs.plugins.completion.config.nvim_cmp"),
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "FelipeLema/cmp-async-path" },
      { "pontusk/cmp-sass-variables" },
      { "lukas-reineke/cmp-rg" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "onsails/lspkind.nvim" },
      { "SergioRibera/cmp-dotenv" },
      {
        {
          "saecki/crates.nvim",
          event = { "BufRead Cargo.toml" },
          dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
          "jcha0713/cmp-tw2css",
          opts = {
            fallback = true,
          },
        },
        {
          "David-Kunz/cmp-npm",
          dependencies = { "nvim-lua/plenary.nvim" },
          ft = "json",
          opts = {
            ignore = {},
            only_semantic_versions = false,
            only_latest_version = false,
          },
        },
        {
          "tamago324/cmp-zsh",
          dependencies = { "Shougo/deol.nvim" },
          opts = {
            zshrc = true,
            filetypes = { "deoledit", "zsh" },
          },
        },
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "jcha0713/cmp-tw2css",
        opts = {
          fallback = true,
        },
      },
      {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "json",
        opts = {
          ignore = {},
          only_semantic_versions = false,
          only_latest_version = false,
        },
      },
      {
        "tamago324/cmp-zsh",
        dependencies = { "Shougo/deol.nvim" },
        opts = {
          zshrc = true,
          filetypes = { "deoledit", "zsh" },
        },
      },
      {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
      },
    },
  },
}
