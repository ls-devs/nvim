local M = {}

M.config = function()
  require("NeoComposer").setup({
    notify = true,
    delay_timer = 150,
    colors = {
      bg = "#16161e00",
      fg = "#ff9e64",
      red = "#ec5f67",
      blue = "#5fb3b3",
      green = "#99c794",
    },
    keymaps = {
      play_macro = "@",
      yank_macro = "yq",
      stop_macro = "cq",
      toggle_record = "Q",
      cycle_next = "<c-n>",
      cycle_prev = "<c-p>",
      toggle_macro_menu = "<c-q>",
    },
  })
end

return M
