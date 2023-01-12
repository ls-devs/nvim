local M = {}

M.config = function()
  local indent_blankline = require("indent_blankline")

  if not indent_blankline then
    return
  end

  indent_blankline.setup()
end

return M
