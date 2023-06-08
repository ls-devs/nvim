local M = {}

M.config = function()
  require("notify").setup({
    background_colour = "#000000",
    top_down = false,
  })
end

return M
