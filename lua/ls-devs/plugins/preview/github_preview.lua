return {
  "wallpants/github-preview.nvim",
  opts = {
    host = "localhost",
    port = 6041,
    single_file = false,
    theme = {
      name = "system",
      high_contrast = false,
    },
    details_tags_open = true,
    cursor_line = {
      disable = false,
      color = "#c86414",
      opacity = 0.2,
    },
    scroll = {
      disable = false,
      top_offset_pct = 35,
    },
    log_level = nil,
  },
  keys = {
    {
      "<leader>gp",
      "<cmd>GithubPreviewToggle<CR>",
      desc = "Github Preview",
      noremap = true,
      silent = true,
    },
  },
}
