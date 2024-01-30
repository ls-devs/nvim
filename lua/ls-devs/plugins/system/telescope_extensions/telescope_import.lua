return {
  "piersolenski/telescope-import.nvim",
  keys = {
    {
      "<leader>fi",
      "<cmd>Telescope import<CR>",
      desc = "Telescope Import",
      noremap = true,
      silent = true,
    },
  },
  config = function()
    require("telescope").load_extension("import")
  end,
}
