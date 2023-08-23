local M = {}

M.config = function()
  local c = require("vscode.colors").get_colors()
  require("vscode").setup({
    -- Alternatively set style in setup
    style = "dark",

    -- Enable transparent background
    transparent = false,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
      vscLineNumber = "#FFFFFF",
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
      Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
      NotifyERRORBorder = { fg = c.vscLightRed },
      NotifyERRORIcon = { fg = c.vscLightRed },
      NotifyERRORTitle = { fg = c.vscLightRed },
      NotifyWARNBorder = { fg = c.vsYellow },
      NotifyWARNIcon = { fg = c.vscYellow },
      NotifyWARNTitle = { fg = c.vsYellowl },
      NotifyINFOBorder = { fg = c.vscLightBlue },
      NotifyINFOIcon = { fg = c.vscLightBlue },
      NotifyINFOTitle = { fg = c.vscLightBlue },
      NotifyDEBUGBorder = { fg = c.vscOrange },
      NotifyDEBUGIcon = { fg = c.vscOrange },
      NotifyDEBUGTitle = { fg = c.vscOrange },
      NotifyTRACEBorder = { fg = c.vscPink },
      NotifyTRACEIcon = { fg = c.vscPink },
      NotifyTRACETitle = { fg = c.vscPink },
    },
  })

  require("vscode").load()
end

return M
