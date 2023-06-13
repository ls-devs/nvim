local M = {}

M.config = function()
  local live_server = require("live-server")
  live_server.setup()
end

return M
