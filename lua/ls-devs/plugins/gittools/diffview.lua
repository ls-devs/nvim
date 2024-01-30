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

return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>dvo",
      "<cmd>lua DiffviewToggle()<CR>",
      desc = "DiffviewOpen",
      noremap = true,
      silent = true,
    },
  },
  cond = function()
    return vim.fn.isdirectory(".git") == 1
  end,
}
