local M = {}

M.config = function()
  require("urlview").setup()
end

M.keys = {
  {
    "<leader>ul",
    "<cmd>UrlView lazy<CR>",
    desc = "UrlView Lazy",
  },
  {
    "<leader>ub",
    "<cmd>UrlView buffer<CR>",
    desc = "UrlView Buffer",
  },
  {
    "<leader>uf",
    "<cmd>UrlView file<CR>",
    desc = "UrlView File",
  },
}

return M
