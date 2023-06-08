local M = {}

M.config = function()
  require("gitsigns").setup({
     current_line_blame = true,
  })
end

return M
