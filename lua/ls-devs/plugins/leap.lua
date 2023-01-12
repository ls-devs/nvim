local M = {}

M.config = function()
  require("leap").add_default_mappings()
end

M.keys = { "s", "S" }

return M
