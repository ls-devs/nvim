return {
  "xiyaowong/telescope-emoji.nvim",
  cmd = "Telescope emoji",
  keys = {
    {
      "<leader>fe",
      "<cmd>Telescope emoji<CR>",
      desc = "Telescope Emoji",
    },
  },
  config = function()
    require("telescope").load_extension("emoji")
  end,
}
