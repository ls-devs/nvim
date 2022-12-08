local codelldb_path = vim.env.HOME .. "/.vscode-insiders/extensions/vadimcn.vscode-lldb-1.8.1/adapter/codelldb"
local dap = require("dap")
dap.adapters.python = {
	type = "executable",
	command = "python3.10",
	args = { "-m", "debugpy.adapter" },
}

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_path,
		args = { "--port", "${port}" },
	},
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

dap.configurations.cpp = {
	{
		name = "Launch file",

		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
