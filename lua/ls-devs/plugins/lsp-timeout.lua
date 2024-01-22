local M = {}

M.config = function()
  vim.g.lspTimeoutConfig = {
    stopTimeout = 1000 * 60 * 7, -- ms, timeout before stopping all LSP servers
    startTimeout = 500,        -- ms, timeout before restart
    silent = false,            -- true to suppress notifications
  }
end

return M
