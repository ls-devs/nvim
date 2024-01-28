return function()
  local mason_nvim_dap = require("mason-nvim-dap")
  mason_nvim_dap.setup({
    ensure_installed = {
      "python",
      "node2",
      "php",
      "codelldb",
      "js",
      "chrome",
      "kotlin-debug-adapter",
    },
    automatic_setup = true,
    automatic_installation = true,
  })
end
