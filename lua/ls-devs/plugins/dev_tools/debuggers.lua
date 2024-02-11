return {
	"rcarriga/nvim-dap-ui",
	config = function()
		require("dapui").setup()
		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
			require("nvim-dap-virtual-text").refresh()
		end

		dap.listeners.after.disconnect["dapui_config"] = function()
			require("dap.repl").close()
			dapui.close()
			require("nvim-dap-virtual-text").refresh()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
			require("nvim-dap-virtual-text").refresh()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
			require("nvim-dap-virtual-text").refresh()
		end
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
	end,
	dependencies = {
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				{
					"jay-babu/mason-nvim-dap.nvim",
					config = function()
						require("mason-nvim-dap").setup({
							automatic_setup = true,
							handlers = {
								function(config)
									require("mason-nvim-dap").default_setup(config)
								end,
							},
						})
					end,
				},
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {
				enabled = true, -- enable this plugin (the default)
				enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
				highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				show_stop_reason = true, -- show stop reason when stopped for exceptions
				commented = false, -- prefix virtual text with comment string
				only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
				all_references = false, -- show virtual text on all all references of the variable (not only definitions)
				clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,
				-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

				all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
				virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
				virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
			},
		},
	},
	keys = {
		{
			"<leader>uo",
			mode = { "n" },
			function()
				require("dapui").toggle()
			end,
			desc = "DapUI Toggle",
			noremap = true,
			silent = true,
		},
		{
			"<leader>uc",
			"<cmd>lua require('dapui').close()<CR>",
			desc = "DapUI Close",
			noremap = true,
			silent = true,
		},
		{
			"<leader>un",
			":DapContinue<CR>",
			desc = "DapContinue",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ut",
			":DapTerminate<CR>",
			desc = "DapTerminate",
			noremap = true,
			silent = true,
		},
		{
			"<leader>bb",
			":DapToggleBreakpoint<CR>",
			desc = "DapToggleBreakpoint",
			noremap = true,
			silent = true,
		},
	},
}
