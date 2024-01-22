local M = {}

M.config = function()
  require("overseer").setup({
    strategy = {
      "toggleterm",
      auto_scroll = true,
    },
    float_opts = {
      winblend = 0,
    },
    form = {
      win_opts = {
        winblend = 0,
      },
    },
    confirm = {
      win_opts = {
        winblend = 0,
      },
    },
    task_win = {
      win_opts = {
        winblend = 0,
      },
    },
    task_list = {
      bindings = {
        ["?"] = "ShowHelp",
        ["g?"] = "ShowHelp",
        ["<CR>"] = "RunAction",
        ["<C-e>"] = "Edit",
        ["o"] = "Open",
        ["<C-v>"] = "OpenVsplit",
        ["<C-s>"] = "OpenSplit",
        ["<C-f>"] = "OpenFloat",
        ["<C-q>"] = "OpenQuickFix",
        ["p"] = "TogglePreview",
        ["<C-o>"] = "IncreaseDetail",
        ["<C-c>"] = "DecreaseDetail",
        ["L"] = "IncreaseAllDetail",
        ["H"] = "DecreaseAllDetail",
        ["["] = "DecreaseWidth",
        ["]"] = "IncreaseWidth",
        ["{"] = "PrevTask",
        ["}"] = "NextTask",
        ["<C-k>"] = "ScrollOutputUp",
        ["<C-j>"] = "ScrollOutputDown",
      },
    },
  })
end

-- Fix Overseer with Windows
local isOpen = false
function OverseerToggle()
  if not isOpen then
    vim.cmd(":OverseerToggle")
    vim.cmd(":WindowsDisableAutowidth")
    isOpen = true
  else
    vim.cmd(":OverseerToggle")
    vim.cmd(":WindowsEnableAutowidth")
    isOpen = false
  end
end

M.keys = {
  { "<leader>or", "<cmd>OverseerRun<CR>",          desc = "Overseer Run" },
  { "<leader>ot", "<cmd>lua OverseerToggle()<CR>", desc = "Overseer Toggle" },
}

return M
