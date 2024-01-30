return {
  "jonarrien/telescope-cmdline.nvim",
  keys = {
    {
      "<leader>fcm",
      "<cmd>Telescope cmdline<CR>",
      desc = "Telescope cmdline",
      noremap = true,
      silent = true,
    },
  },
  config = function()
    require("telescope").load_extension("cmdline")
  end,
}
