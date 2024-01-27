return {
  "nanozuki/tabby.nvim",
  event = "BufReadPost",
  config = function()
    local getTabName = function()
      local tail = vim.fn.expand("%:t")
      if string.find(tail, "filesystem") or tail == "Overseer task builder" then
        return vim.bo.filetype
      end
      if string.find(tail, "toggleterm") then
        local pID = string.gsub(tail, "%d+:", "")
        return string.gsub(pID, ";#toggleterm#%d+", "")
      end
      if string.find(tail, "npm") then
        return string.gsub(tail, "%d+:", "")
      end
      if tail == "" then
        if vim.bo.filetype == "" then
          return "[No Name]"
        else
          return vim.bo.filetype
        end
      end
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
            tab.is_current() and getTabName() or tab.name(),
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
            hl = { bg = colors.bg_dark, fg = colors.fg },
            margin = " ",
          }
        end),
        hl = { bg = colors.none },
      }
    end)
  end,
  keys = {
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
  },
  dependencies = "nvim-tree/nvim-web-devicons",
}
