local M = {}

M.config = function()
  local dap, dapui = require("dap"), require("dapui")
  local mason_nvim_dap = require("mason-nvim-dap")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.after.event_exited["dapui_config"] = function()
    dapui.close()
  end

  mason_nvim_dap.setup({
    ensure_installed = {
      "python",
      "node2",
      "php",
      "codelldb",
      "js",
      "chrome",
    },
    automatic_setup = true,
    automatic_installation = true,
  })

  mason_nvim_dap.setup_handlers({
    function(source_name)
      require("mason-nvim-dap.automatic_setup")(source_name)
    end,
  })
end

return M
