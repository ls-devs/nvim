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
      show_file = true,
      folder_level = 2,
      respect_root = false,
      color_mode = true,
      border_follow = false,
    },
    hover = {
      open_browser = "!brave",
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
