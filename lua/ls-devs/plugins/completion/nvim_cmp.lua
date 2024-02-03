return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "BufReadPre", "CmdlineEnter" },
    config = require("ls-devs.plugins.completion.config.nvim_cmp"),
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { url = "https://codeberg.org/FelipeLema/cmp-async-path" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "onsails/lspkind.nvim" },
      { "SergioRibera/cmp-dotenv" },
      {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
      },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        event = "InsertEnter",
        build = "make install_jsregexp",
      },
      { "saadparwaiz1/cmp_luasnip" },
    },
  },
}
