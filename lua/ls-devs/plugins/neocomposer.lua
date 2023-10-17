local M = {}

M.config = function()
  require("NeoComposer").setup({
    notify = true,
    delay_timer = 150,
    colors = {
      bg = nil,
      fg = "#ff9e64",
      red = "#ec5f67",
      blue = "#5fb3b3",
      green = "#99c794",
    },
    queue_most_recent = false,
    window = {
      border = "rounded",
      winhl = {
        Normal = "Normal",
      },
    },
    keymaps = {
      play_macro = "Q",
      yank_macro = "yq",
      stop_macro = "cq",
      toggle_record = "q",
      cycle_next = "<c-n>",
      cycle_prev = "<c-p>",
      toggle_macro_menu = "<c-q>",
    },
  })
end

return M
