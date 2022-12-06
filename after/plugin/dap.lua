local dap = require("dap")
dap.adapters.python = {
	type = "executable",
	command = "python3.10",
	args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		pythonPath = function()
			return "/usr/bin/python3.10"
		end,
	},
}
