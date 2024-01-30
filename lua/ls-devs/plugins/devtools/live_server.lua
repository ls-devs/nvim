return {
  "barrett-ruth/live-server.nvim",
  keys = {
    {
      "<leader>ss",
      "<cmd>LiveServerStart<CR>",
      desc = "Start Live Server",
      noremap = true,
      silent = true,
    },
    {
      "<leader>sk",
      "<cmd>LiveServerStop<CR>",
      desc = "Stop Live Server",
      noremap = true,
      silent = true,
    },
  },
  build = "pnpm i -g live-server",
}
