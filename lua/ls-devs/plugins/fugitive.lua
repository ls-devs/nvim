local M = {}

M.keys = {
  { "<leader>gg",  "<cmd>Git<CR>",          desc = "Git Fugitive" },
  { "<leader>gc",  "<cmd>Gdiffsplit!<CR>",  desc = "Git Conflict Vertical" },
  { "<leader>gcv", "<cmd>Gvdiffsplit!<CR>", desc = "Git Conflict" },
}

return M
