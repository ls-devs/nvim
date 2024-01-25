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
        { "  ", hl = { fg = colors.green, bg = colors.none, style = "bold" } },
        line.sep(" ", { bg = colors.none }, { bg = colors.none }),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep("", hl, { bg = colors.none }),
          tab.is_current() and "" or "󰆣",
          fName(tab.name()),
          tab.close_btn(""),
          line.sep("", hl, { bg = colors.none }),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep("", theme.win, { bg = colors.none }),
          win.is_current() and "  " or "  ",
          line.sep("", theme.win, { bg = colors.none }),
          hl = theme.win,
          margin = " ",
        }
      end),
      {
        line.sep("", theme.tail, { bg = colors.none }),
        { "  ", hl = { bg = colors.bg_dark, fg = colors.green } },
      },
      hl = { bg = colors.none },
    }
  end)
end
return M
