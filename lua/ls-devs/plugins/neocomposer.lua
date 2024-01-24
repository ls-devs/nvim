local M = {}

M.config = function()
  -- Disable "q" for macro
  vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })
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
    keymaps = {
      play_macro = "@",
      yank_macro = "yq",
      stop_macro = "cq",
      toggle_record = "<A-q>",
      cycle_next = "<leader>qn",
      cycle_prev = "<leader>qp",
      toggle_macro_menu = "<leader>q",
    },
  })
end

return M
