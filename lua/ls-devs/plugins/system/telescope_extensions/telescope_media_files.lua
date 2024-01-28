return {
  "nvim-telescope/telescope-media-files.nvim",
  cmd = "Telescope media_files",
  keys = {
    {
      "<leader>tm",
      "<cmd>Telescope media_files<CR>",
      desc = "Telescope Media Files",
    },
  },
  config = function()
    require("telescope").load_extension("media_files")
  end,
}
