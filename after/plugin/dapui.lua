local dap, dapui = require("dap"), require("dapui")
local tree = require("nvim-tree.api").tree
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
	tree.close()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dapui.setup()
