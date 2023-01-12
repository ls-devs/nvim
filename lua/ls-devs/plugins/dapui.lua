local M = {}

M.config = function()
  local dap, dapui = require("dap"), require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.after.event_exited["dapui_config"] = function()
    dapui.close()
  end

  dapui.setup()
end

M.keys = {
  { "<leader>uo", "<cmd>lua require('dapui').toggle()<CR>", desc = "DapUI Toggle" },
  { "<leader>uc", "<cmd>lua require('dapui').close()<CR>", desc = "DapUI Close" },
  { "<leader>un", ":DapContinue<CR>", desc = "DapContinue" },
  { "<leader>ut", ":DapTerminate<CR>", desc = "DapTerminate" },
  { "<leader>bb", ":DapToggleBreakpoint<CR>", desc = "DapToggleBreakpoint" }
}

return M
