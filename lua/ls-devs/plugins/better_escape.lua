local M = {}

M.config = function()
  require("better_escape").setup({
    timeout = 200,
  })
end

return M
