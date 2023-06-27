local M = {}

M.config = function()
  require("dapui").setup()
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
end

M.keys = {
  {
    "<leader>uo",
    mode = { "n" },
    function()
      require("dapui").toggle()
    end,
    desc = "DapUI Toggle",
  },
  { "<leader>uc", "<cmd>lua require('dapui').close()<CR>", desc = "DapUI Close" },
  { "<leader>un", ":DapContinue<CR>",                      desc = "DapContinue" },
  { "<leader>ut", ":DapTerminate<CR>",                     desc = "DapTerminate" },
  { "<leader>bb", ":DapToggleBreakpoint<CR>",              desc = "DapToggleBreakpoint" },
}

return M
