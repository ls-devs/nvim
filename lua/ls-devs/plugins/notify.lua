local M = {}

M.config = function()
  require("notify").setup({
    background_colour = "#000000",
    render = "compact",
  })
end

return M
