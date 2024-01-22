local M = {}

M.config = function()
  local colors = require("tokyonight.colors").setup()
  require("NeoComposer").setup({
    notify = false,
    delay_timer = 150,
    colors = {
      bg = colors.none,
      fg = colors.orange,
      red = colors.red,
      blue = colors.blue,
      green = colors.green,
    },
    queue_most_recent = true,
    window = {
      border = "rounded",
      winhl = {
        Normal = "Normal",
      },
    },
  })
end

return M
