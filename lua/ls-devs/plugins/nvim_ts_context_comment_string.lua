local M = {}

M.config = function()
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })
end

return M
