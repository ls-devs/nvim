return {
  "mrjones2014/legendary.nvim",
  event = "VeryLazy",
  config = require("ls-devs.plugins.keymap.config.legendary"),
  dependencies = {
    { "kkharji/sqlite.lua" },
    -- Smart Splits
    {
      "mrjones2014/smart-splits.nvim",
      event = "VeryLazy",
      build = "./kitty/install-kittens.bash",
      opts = {
        resize_mode = {
          silent = true,
          hooks = {
            on_enter = function()
              vim.notify("Entering resize mode")
            end,
            on_leave = function()
              vim.notify("Exiting resize mode, bye")
            end,
          },
        },
      },
    },
  },
}
