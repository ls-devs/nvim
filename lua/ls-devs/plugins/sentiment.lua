local M = {}

M.config = function()
  vim.g.loaded_matchparen = 1
  require("sentiment").setup({})
end

return M
