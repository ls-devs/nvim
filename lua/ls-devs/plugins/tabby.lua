local M = {}

M.config = function()
  -- TabName
  local getTabName = function()
    -- Get tail of path
    local tail = vim.fn.expand("%:t")

    -- Handle empty tail / neo-tree / Overseer
    if tail == "" or tail == "neo-tree filesystem [1]" or tail == "Overseer task builder" then
      return vim.bo.filetype
    end

    -- Handle toggleterm
    if string.find(tail, "toggleterm") then
      local pID = string.gsub(tail, "%d+:", "")
      return string.gsub(pID, ";#toggleterm#%d+", "")
    end

    -- Handle Overseer custom task
    if string.find(tail, "npm") then
      return string.gsub(tail, "%d+:", "")
    end

    -- Handle Length
    if string.len(tail) > 25 then
      local fileExt = string.match(tail, "[^.]+$")
      return string.sub(tail, 0, 22 - string.len(fileExt)) .. "..." .. fileExt
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
        local hl = tab.is_current() and "TabLineSel" or "TabLine"
        return {
          line.sep("", hl, { bg = colors.none }),
          tab.is_current() and "" or "󰆣",
          getTabName(),
          tab.close_btn(""),
          line.sep("", hl, { bg = colors.none }),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep("", "TabLine", { bg = colors.none }),
          win.is_current() and "  " or "  ",
          line.sep("", "TabLine", { bg = colors.none }),
          hl = "TabLine",
          margin = " ",
        }
      end),
      {
        line.sep("", "TabLine", { bg = colors.none }),
        { "  ", hl = { bg = colors.bg_dark, fg = colors.green } },
      },
      hl = { bg = colors.none },
    }
  end)
end

M.keys = {
  {
    "<leader>tn",
    ":$tabnew<CR>",
    desc = "New Tab",
  },
  {
    "<leader>tc",
    ":tabclose<CR>",
    desc = "Close Tab",
  },
  {
    "<leader>to",
    ":tabonly<CR>",
    desc = "Tab Only",
  },
  {
    "<A-f>",
    ":tabn<CR>",
    desc = "Tab Next",
  },
  {
    "<A-b>",
    ":tabp<CR>",
    desc = "Tab Previous",
  },
  {
    "<leader>tmp",
    ":-tabmove<CR>",
    desc = "Tab Move Previous",
  },
  {
    "<leader>tmn",
    ":+tabmove<CR>",
    desc = "Tab Move Next",
  },
}

return M
