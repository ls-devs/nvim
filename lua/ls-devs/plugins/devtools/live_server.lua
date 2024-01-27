return {
  "barrett-ruth/live-server.nvim",
  keys = {
    { "<leader>ss", "<cmd>LiveServerStart<CR>", desc = "Start Live Server" },
    { "<leader>sk", "<cmd>LiveServerStop<CR>",  desc = "Stop Live Server" },
  },
  build = "pnpm i -g live-server",
}
