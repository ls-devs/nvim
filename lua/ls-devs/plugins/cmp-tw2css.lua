local M = {}

M.config = function()
  require("cmp-tw2css").setup({
    fallback = true,
  })
end

return M
