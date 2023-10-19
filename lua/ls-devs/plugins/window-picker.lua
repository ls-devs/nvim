local M = {}

M.config = function()
  require("window-picker").setup({
    hint = "floating-big-letter",
    show_prompt = true,
    picker_config = {
      floating_big_letter = {
        font = "ansi-shadow",
      },
    },
    filter_rules = {
      autoselect_one = true,
      include_current_win = false,
      bo = {
        filetype = { "NvimTree", "neo-tree", "neo-tree-popup", "NeoTreeFloat", "notify" },
        buftype = { "terminal", "quickfix" },
      },
    },
    highlights = {
      statusline = {
        focused = {
          fg = "#ededed",
          bg = "#e35e4f",
          bold = true,
        },
        unfocused = {
          fg = "#ededed",
          bg = "#44cc41",
          bold = true,
        },
      },
      winbar = {
        focused = {
          fg = "#ededed",
          bg = "#e35e4f",
          bold = true,
        },
        unfocused = {
          fg = "#ededed",
          bg = "#44cc41",
          bold = true,
        },
      },
    },
  })
end

return M
