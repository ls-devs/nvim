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

return M
