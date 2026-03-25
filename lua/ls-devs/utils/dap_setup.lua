-- dap_setup.lua
-- Generic DAP (Debug Adapter Protocol) and UI configuration for Neovim
-- Plug-and-play: requires nvim-dap, nvim-dap-ui, nvim-dap-virtual-text

local M = {}

function M.setup()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup()

  -- Auto-open UI when a debug session starts (attach or launch)
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
    pcall(function() require("nvim-dap-virtual-text").refresh() end)
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
    pcall(function() require("nvim-dap-virtual-text").refresh() end)
  end

  -- Auto-close when the debuggee process terminates or exits
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    pcall(function() require("nvim-dap-virtual-text").refresh() end)
  end
  dap.listeners.before.event_exited["dapui_config"] = function(_, body)
    dapui.close()
    pcall(function() require("nvim-dap-virtual-text").refresh() end)
    local code = body and body.exitCode or "?"
    if code == 0 then
      vim.notify("[DAP] Process exited (code 0)", vim.log.levels.INFO)
    else
      vim.notify("[DAP] Process exited with code " .. tostring(code), vim.log.levels.WARN)
    end
  end

  -- Gutter signs for breakpoint variants
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
end

return M
