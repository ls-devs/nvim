local M = {}

M.config = function()
  require("lspsaga").setup({
    symbol_in_winbar = {
      enable = true,
      separator = "  ",
      ignore_patterns = {},
      hide_keyword = true,
      show_file = true,
      folder_level = 2,
      respect_root = false,
      color_mode = true,
    },
    hover = {
      open_browser = "!brave"
    },
    rename = {
      quit = "<ESC>",
      exec = "<CR>",
      mark = "x",
      confirm = "<CR>",
      in_select = true,
    },
  })
end

return M
