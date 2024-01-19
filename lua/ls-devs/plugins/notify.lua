local M = {}

M.config = function()
  require("notify").setup({
    background_colour = "#000000",
    top_down = false,
    timeout = 1000,
  })
end

return M
