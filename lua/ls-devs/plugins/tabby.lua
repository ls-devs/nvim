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
  local getFileName = function()
    local tail = vim.fn.expand("%:t")
    if string.len(tail) > 25 then
      local fileExt = string.match(tail, "[^.]+$")
      return string.sub(tail, 0, 22 - string.len(fileExt)) .. "..." .. fileExt
    elseif tail == "" or tail == "neo-tree filesystem [1]" or tail == "Overseer task builder" then
      return vim.bo.filetype
    elseif string.find(tail, "toggleterm") then
      local pID = string.gsub(tail, "%d+:", "")
      return string.gsub(pID, ";#toggleterm#%d+", "")
    else
      return tail
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
          getFileName(),
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
