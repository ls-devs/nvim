local M = {}

M.config = function()
  local mason_nvim_dap = require("mason-nvim-dap")
  mason_nvim_dap.setup({
    ensure_installed = {
      "python",
      "node2",
      "php",
      "codelldb",
      "js",
      "chrome",
      "haskell",
      "kotlin-debug-adapter",
    },
    automatic_setup = true,
    automatic_installation = true,
  })
end

return M
