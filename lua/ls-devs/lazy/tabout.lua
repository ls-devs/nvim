local M = {}

M.config = function()
  local tabout = require("tabout")
  if not tabout then
    return
  end

  tabout.setup({})
end

return M
