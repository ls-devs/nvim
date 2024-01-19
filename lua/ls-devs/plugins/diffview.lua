local M = {}

M.config = function()
  require("diffview").setup()
end

M.keys = {
  { "<leader>dvo", "<cmd>DiffviewOpen<CR>",  desc = "DiffviewOpen" },
  { "<leader>dvc", "<cmd>DiffviewClose<CR>", desc = "DiffviewClose" },
}

return M
