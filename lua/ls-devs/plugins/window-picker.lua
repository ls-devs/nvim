local M = {}

M.config = function()
  require("window-picker").setup({
    autoselect_one = true,
    include_current = false,
    filter_rules = {
      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = { "NvimTree", "neo-tree", "neo-tree-popup", "NeoTreeFloat", "notify" },

        -- if the buffer type is one of following, the window will be ignored
        buftype = { "terminal", "quickfix" },
      },
    },
    -- other_win_hl_color = "#e35e4f",
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
