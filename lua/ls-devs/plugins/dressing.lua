local M = {}

M.config = function()
  local dressing = require("dressing")

  dressing.setup({
    input = {
      enabled = true,
      start_in_insert = false,
    },
    select = {
      -- Set to false to disable the vim.ui.select implementation
      enabled = true,
    },
  })
end

return M
