return {
  "folke/todo-comments.nvim",
  event = "BufReadPost",
  config = true,
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    {
      "<leader>T",
      "<cmd>TodoTrouble<CR>",
      desc = "TodoTrouble",
      silent = true,
      noremap = true,
    },
    {
      "<leader>TT",
      "<cmd>TodoTelescope<CR>",
      desc = "TodoTelescope",
      silent = true,
      noremap = true,
    },
  },
}
