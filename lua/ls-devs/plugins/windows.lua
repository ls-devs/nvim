local M = {}

M.config = function()
  vim.o.winwidth = 10
  vim.o.winminwidth = 10
  vim.o.equalalways = false
  require("windows").setup({
    ignore = { --			  |windows.ignore|
      buftype = { "quickfix" },
      filetype = {
        "NvimTree",
        "neo-tree",
        "undotree",
        "gundo",
        "Diffview",
        "DiffviewFiles",
        "terminal",
        "toggleterm",
      },
    },
  })
end

M.keys = {
  {
    "<leader>wm",
    ":WindowsMaximize<CR>",
    desc = "Maximize Windows",
  },
  {
    "<leader>wv",
    ":WindowsMaximizeVertically<CR>",
    desc = "Maximize Windows Vertically",
  },
  {
    "<leader>wh",
    ":WindowsMaximizeHorizontally<CR>",
    desc = "Maximize Windows Horizontally",
  },
  {
    "<leader>wt",
    ":WindowsToggleAutowidth<CR>",
    desc = "Toggle Windows AutoWidth",
  },
  {
    "<leader>we",
    ":WindowsEqualize<CR>",
    desc = "Equalize Window",
  },
}

return M
