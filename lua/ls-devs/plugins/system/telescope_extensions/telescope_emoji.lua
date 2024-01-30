return {
  "xiyaowong/telescope-emoji.nvim",
  keys = {
    {
      "<leader>fe",
      "<cmd>Telescope emoji<CR>",
      desc = "Telescope Emoji",
      noremap = true,
      silent = true,
    },
  },
  config = function()
    require("telescope").load_extension("emoji")
  end,
}
