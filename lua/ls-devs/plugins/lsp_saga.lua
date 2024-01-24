local M = {}

M.config = function()
  require("lspsaga").setup({
    lightbulb = {
      enable = false,
      enable_in_insert = false,
    },
    symbol_in_winbar = {
      enable = true,
      separator = "  ",
      ignore_patterns = {},
      hide_keyword = true,
      show_file = false,
      folder_level = 0,
      respect_root = true,
      color_mode = true,
      border_follow = false,
      winblend = 0,
    },
    hover = {
      border_follow = false,
    },
    diagnostic = {
      border_follow = false,
    },
    rename = {
      quit = "<ESC>",
      exec = "<CR>",
      mark = "x",
      confirm = "<CR>",
      in_select = true,
    },
    ui = {
      -- This option only works in Neovim 0.9
      title = true,
      -- Border type can be single, double, rounded, solid, shadow.
      border = "rounded",
      winblend = 0,
      expand = "",
      collapse = "",
      code_action = "💡",
      incoming = " ",
      outgoing = " ",
      hover = " ",
    },
    beacon = {
      enable = true,
      frequency = 7,
    },
  })
end

return M
