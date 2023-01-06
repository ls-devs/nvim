local dap = require("dap")

require("mason-nvim-dap").setup({
	ensure_installed = {
		"debugpy",
		"codelldb",
		"node-debug2-adapter",
		"php-debug-adapter",
		"go-debug-adapter",
		"js-debug-adapter",
	},
	automatic_setup = true,
})

require("mason-nvim-dap").setup_handlers({
	function(source_name)
		require("mason-nvim-dap.automatic_setup")(source_name)
	end,
	python = function()
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
})
