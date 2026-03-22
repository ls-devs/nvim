-- ── nvim-dap-ui ───────────────────────────────────────────────────────────
-- Purpose : Full DAP debugging ecosystem for Neovim
-- Trigger : keys (<leader>bb / <leader>un / <leader>ut / <leader>uo / <leader>uc)
-- Provides: nvim-dap (protocol client), nvim-dap-ui (visual panels),
--           nvim-dap-virtual-text (inline variable values in source)
-- Note    : mason-nvim-dap (configured in manager.lua) handles adapter
--           auto-setup; JS/TS adapters use pwa-node/pwa-chrome from
--           js-debug-adapter (installed via Mason)
-- ─────────────────────────────────────────────────────────────────────────
return {
	"rcarriga/nvim-dap-ui",
	config = function()
		require("dapui").setup()
		local dap, dapui = require("dap"), require("dapui")
		-- Auto-open UI when a debug session starts (attach or launch)
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
			require("nvim-dap-virtual-text").refresh()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
			require("nvim-dap-virtual-text").refresh()
		end

		-- Auto-close when the debuggee process terminates normally
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
			require("nvim-dap-virtual-text").refresh()
		end

		-- Auto-close when the debuggee process exits with a code
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
			require("nvim-dap-virtual-text").refresh()
		end

		-- Gutter signs for breakpoint variants
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
			config = function()
				local dap = require("dap")
				-- pwa-node / pwa-chrome configs applied to all JS/TS-family filetypes
				for _, language in ipairs({
					"typescript",
					"javascript",
					"typescriptreact",
					"javascriptreact",
					"vue",
				}) do
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = vim.fn.getcwd(),
							sourceMaps = true,
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = vim.fn.getcwd(),
							sourceMaps = true,
						},
						{
							type = "pwa-chrome",
							request = "launch",
							name = "Launch & Debug Chrome",
							url = function()
								local co = coroutine.running()
								return coroutine.create(function()
									vim.ui.input({
										prompt = "Enter URL: ",
										default = "http://localhost:3000",
									}, function(url)
										if url == nil or url == "" then
											return
										else
											coroutine.resume(co, url)
										end
									end)
								end)
							end,
							webRoot = vim.fn.getcwd(),
							protocol = "inspector",
							sourceMaps = true,
							userDataDir = false,
						},
						{
							name = "----- ↓ launch.json configs ↓ -----",
							type = "",
							request = "launch",
						},
					}
				end
			end,
			dependencies = {
				-- {
				-- 	"microsoft/vscode-js-debug",
				-- 	build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				-- },
				-- {
				-- 	"mxsdev/nvim-dap-vscode-js",
				-- 	config = function()
				-- 		require("dap-vscode-js").setup({
				-- 			debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
				-- 			adapters = {
				-- 				"chrome",
				-- 				"pwa-node",
				-- 				"pwa-chrome",
				-- 				"pwa-msedge",
				-- 				"pwa-extensionHost",
				-- 				"node-terminal",
				-- 			},
				-- 		})
				-- 	end,
				-- },
				{
					"Joakker/lua-json5",
					build = "./install.sh", -- enables launch.json with JSON5 syntax (comments, trailing commas)
				},
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			lazy = true,
			opts = {
				enabled = true,
				enable_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,

				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol", -- inline requires Neovim ≥ 0.10

				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			},
		},
	},
	keys = {
		-- UI toggle
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
		-- Session control
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
		-- Breakpoints
		{
			"<leader>bb",
			":DapToggleBreakpoint<CR>",
			desc = "DapToggleBreakpoint",
			noremap = true,
			silent = true,
		},
	},
}
