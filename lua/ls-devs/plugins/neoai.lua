local M = {}

M.config = function()
  require("neoai").setup({})
end

M.keys = {
  { "<leader>as", desc = "summarize text" },
  { "<leader>ag", desc = "generate git message" },
}

return M
