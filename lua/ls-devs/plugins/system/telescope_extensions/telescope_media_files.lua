return {
  "nvim-telescope/telescope-media-files.nvim",
  keys = {
    {
      "<leader>tm",
      "<cmd>Telescope media_files<CR>",
      desc = "Telescope Media Files",
      noremap = true,
      silent = true,
    },
  },
  config = function()
    require("telescope").load_extension("media_files")
  end,
}
