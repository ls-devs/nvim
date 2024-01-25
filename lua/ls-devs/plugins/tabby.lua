local M = {}

M.config = function()
  local theme = {
    fill = "TabLineFill",
    head = "TabLine",
    current_tab = "TabLineSel",
    tab = "TabLine",
    win = "TabLine",
    tail = "TabLine",
  }
  local fName = function(str)
    if string.len(str) > 25 then
      local fileExt = string.match(str, "[^.]+$")
      return string.sub(str, 0, 22 - string.len(fileExt)) .. "..." .. fileExt
    else
      return str
    end
  end
  require("tabby").setup({})
  local colors = require("tokyonight.colors").setup()
  require("tabby.tabline").set(function(line)
    return {
      {
        { "  ", hl = { fg = colors.green, bg = vim.g["terminal_color_0"], style = "bold" } },
        line.sep("", theme.fill, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep("", hl, theme.fill),
          tab.is_current() and "" or "󰆣",
          tab.number(),
          fName(tab.name()),
          tab.close_btn(""),
          line.sep("", hl, theme.fill),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep("", theme.win, theme.fill),
          win.is_current() and "" or "",
          line.sep("", theme.win, theme.fill),
          hl = theme.win,
          margin = " ",
        }
      end),
      {
        line.sep("", theme.tail, theme.fill),
        { "  ", hl = theme.tail },
      },
      hl = theme.fill,
    }
  end)
end

return M
