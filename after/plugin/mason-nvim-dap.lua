local codelldb_path = vim.env.HOME .. "/.vscode-insiders/extensions/vadimcn.vscode-lldb-1.8.1/adapter/codelldb"
local dap = require("dap")

require("mason-nvim-dap").setup({
	ensure_installed = { "cpptools" },
	automatic_setup = true,
})

require("mason-nvim-dap").setup_handlers({
	function(source_name)
		-- all sources with no handler get passed here

		-- Keep original functionality of `automatic_setup = true`
		require("mason-nvim-dap.automatic_setup")(source_name)
	end,
	python = function(source_name)
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
	end,

	--[[ cppdbg = function(source_name) ]]
	--[[ 	dap.adapters.codelldb = { ]]
	--[[ 		type = "server", ]]
	--[[ 		port = "${port}", ]]
	--[[ 		executable = { ]]
	--[[ 			command = codelldb_path, ]]
	--[[ 			args = { "--port", "${port}" }, ]]
	--[[ 		}, ]]
	--[[ 	} ]]
	--[[ 	dap.configurations.cpp = { ]]
	--[[ 		{ ]]
	--[[ 			name = "Launch file", ]]
	--[[]]
	--[[ 			type = "codelldb", ]]
	--[[ 			request = "launch", ]]
	--[[ 			program = function() ]]
	--[[ 				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") ]]
	--[[ 			end, ]]
	--[[ 			cwd = "${workspaceFolder}", ]]
	--[[ 			stopOnEntry = false, ]]
	--[[ 		}, ]]
	--[[ 	} ]]
	--[[ 	dap.configurations.c = dap.configurations.cpp ]]
	--[[ 	dap.configurations.rust = dap.configurations.cpp ]]
	--[[ end, ]]
})
