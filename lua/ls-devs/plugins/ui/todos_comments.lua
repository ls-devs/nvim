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
    },
    {
      "<leader>TT",
      "<cmd>TodoTelescope<CR>",
      desc = "TodoTelescope",
    },
  },
}