local M = {}

M.config = function()
  local live_server = require("live-server")
  live_server.setup()
end

M.keys = {
  { "<leader>ss", "<cmd>LiveServerStart<CR>", desc = "Start Live Server" },
  { "<leader>sk", "<cmd>LiveServerStop<CR>",  desc = "Stop Live Server" },
}

return M
