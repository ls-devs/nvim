local M = {}

M.config = function()
  require("data-viewer").setup({
    autoDisplayWhenOpenFile = false,
    maxLineEachTable = 100,
    columnColorEnable = true,
    columnColorRoulette = { -- Highlight groups
      "DataViewerColumn0",
      "DataViewerColumn1",
      "DataViewerColumn2",
    },
    view = {
      width = 0.8, -- Less than 1 means ratio to screen width
      height = 0.8, -- Less than 1 means ratio to screen height
      zindex = 50,
    },
    keymap = {
      quit = "q",
      next_table = "<C-l>",
      prev_table = "<C-h>",
    },
  })
end

return M
