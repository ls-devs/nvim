return {
  "piersolenski/telescope-import.nvim",
  cmd = "Telescope import",
  keys = {
    {
      "<leader>fi",
      "<cmd>Telescope import<CR>",
      desc = "Telescope Import",
    },
  },
  config = function()
    require("telescope").load_extension("import")
  end,
}
