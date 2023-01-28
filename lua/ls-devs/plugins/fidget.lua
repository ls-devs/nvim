local M = {}

M.config = function()
  require("fidget").setup({
    window = {
      blend = 0,
    },
  })
end

return M
