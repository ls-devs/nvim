local dap, dapui = require("dap"), require("dapui")
local tree = require("nvim-tree")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
	tree.toggle()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
	tree.open()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
	tree.open()
end

dapui.setup()
