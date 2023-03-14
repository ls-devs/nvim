local M = {}

M.config = function()
  local indent_blankline = require("indent_blankline")

  indent_blankline.setup()
end

return M
