local M = {}

M.config = function()
  local cp = require("catppuccin.palettes").get_palette("mocha")
  require("scrollbar").setup({
    marks = {
      Cursor = { color = cp.text },
      Search = { color = cp.peach },
      Error = { color = cp.red },
      Warn = { color = cp.yellow },
      Info = { color = cp.sky },
      Hint = { color = cp.green },
      Misc = { color = cp.mauve },
    },
    handlers = {
      handle = false,
    },
  })
end

M.hlslens = function()
  require("scrollbar.handlers.search").setup({
    -- hlslens config overrides
  })
end

M.gitsigns = function()
  require("gitsigns").setup()
  require("scrollbar.handlers.gitsigns").setup()
end

return M
