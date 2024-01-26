local M = {}

M.config = function()
  require("todo-comments").setup()
end

M.keys = {
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
}

return M
