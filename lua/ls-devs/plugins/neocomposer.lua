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
      play_macro = "<leader>@",
      yank_macro = "<leader>yq",
      stop_macro = "<leader>sq",
      toggle_record = "<leader>q",
      cycle_next = "<leader>qn",
      cycle_prev = "<leader>qp",
      toggle_macro_menu = "<leader>qm",
    },
  })
end

return M
