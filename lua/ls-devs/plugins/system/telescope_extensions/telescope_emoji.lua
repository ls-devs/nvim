return {
  "xiyaowong/telescope-emoji.nvim",
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
