local M = {}

M.config = function()
  vim.g["lsp-timeout-config"] = {
    stopTimeout = 1000 * 60 * 5, -- ms, timeout before stopping all LSP servers
    startTimeout = 500,        -- ms, timeout before restart
    silent = false,            -- true to suppress notifications
    ignore = { "NeoTree" },
  }
end

return M
