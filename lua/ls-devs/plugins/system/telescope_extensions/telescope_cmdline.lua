return {
  "jonarrien/telescope-cmdline.nvim",
  keys = {
    {
      "<leader>fcm",
      "<cmd>Telescope cmdline<CR>",
      desc = "Telescope Emoji",
    },
  },
  config = function()
    require("telescope").load_extension("cmdline")
  end,
}
