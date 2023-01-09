local M = {}

M.config = function()
  local dressing = require("dressing")

  if not dressing then
    return
  end

  dressing.setup({
    input = {
      enabled = true,
      start_in_insert = false,
    },
  })
end

return M
