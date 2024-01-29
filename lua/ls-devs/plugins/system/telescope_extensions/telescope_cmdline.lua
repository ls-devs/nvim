return {
  "jonarrien/telescope-cmdline.nvim",
  keys = {
    {
      "<leader>fcm",
      "<cmd>Telescope cmdline<CR>",
      desc = "Telescope cmdline",
    },
  },
  config = function()
    require("telescope").load_extension("cmdline")
  end,
}
