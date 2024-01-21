local M = {}

M.config = function()
  require("diffview").setup()
end

-- Fix DiffView with Windows
function DiffviewToggle()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    vim.cmd(":DiffviewClose")
    vim.cmd(":WindowsEnableAutowidth")
  else
    vim.cmd(":WindowsDisableAutowidth")
    vim.cmd(":DiffviewOpen")
  end
end

M.keys = {
  { "<leader>dvo", "<cmd>lua DiffviewToggle()<CR>", desc = "DiffviewOpen" },
}

return M
