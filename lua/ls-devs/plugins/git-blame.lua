local M = {}

M.config = function()
  vim.g.gitblame_highlight_group = "Question"
  require("gitblame").setup({
    enabled = true,
  })
end

return M
