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

dap.adapters.cpp = {
	type = "executable",
	attach = {
		pidProperty = "pid",
		pidSelect = "ask",
	},
	command = "lldb-vscode-15", -- my binary was called 'lldb-vscode-11'
	env = {
		LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
	},
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "lldb",
		type = "cpp",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		externalTerminal = false,
		stopOnEntry = false,
		args = {},
	},
}
