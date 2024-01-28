-- Fix Overseer with Windows
local isOpen = false
function OverseerToggle()
  if not isOpen then
    vim.cmd(":OverseerToggle")
    if vim.fn.exists(":WindowsDisableAutowidth") > 0 then
      vim.cmd(":WindowsDisableAutowidth")
    end
    isOpen = true
  else
    vim.cmd(":OverseerToggle")
    if vim.fn.exists(":WindowsEnableAutowidth") > 0 then
      vim.cmd(":WindowsEnableAutowidth")
    end
    isOpen = false
  end
end

return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup({
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
  end,
  keys = {
    { "<leader>or", "<cmd>OverseerRun<CR>",          desc = "Overseer Run" },
    { "<leader>ot", "<cmd>lua OverseerToggle()<CR>", desc = "Overseer Toggle" },
  },
}
