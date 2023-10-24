local M = {}

M.config = function()
  require("bqf").setup({
    auto_enable = true,
    auto_resize_height = true,
    func_map = {
      open = "<cr>",
      openc = "o",
      vsplit = "v",
      split = "s",
      fzffilter = "f",
      pscrollup = "<C-u>",
      pscrolldown = "<C-d>",
      ptogglemode = "F",
      filter = "n",
      filterr = "N",
    },
    preview = {
      winblend = 0,
    },
  })
end

return M
