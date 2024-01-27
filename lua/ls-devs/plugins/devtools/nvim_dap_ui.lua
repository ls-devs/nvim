return {
  "rcarriga/nvim-dap-ui",
  config = function()
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

    local sign = vim.fn.sign_define

    sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  end,
  keys = {
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
  },
  dependencies = {
    { "mfussenegger/nvim-dap" },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        virt_text_win_col = 80,
        all_frames = true,
        commented = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
      },
    },
  },
}
