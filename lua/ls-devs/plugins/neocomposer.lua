local M = {}

M.config = function()
  require("NeoComposer").setup({
    notify = false,
    delay_timer = 150,
    colors = {
      bg = 0,
      fg = "#ff9e64",
      red = "#ec5f67",
      blue = "#5fb3b3",
      green = "#99c794",
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
