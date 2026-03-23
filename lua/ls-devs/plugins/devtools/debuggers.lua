-- ── nvim-dap-ui ───────────────────────────────────────────────────────────
-- Purpose : Full DAP debugging ecosystem for Neovim
-- Trigger : keys (<leader>bb / <leader>un / <leader>ut / <leader>uo / <leader>uc)
-- Provides: nvim-dap (protocol client), nvim-dap-ui (visual panels),
--           nvim-dap-virtual-text (inline variable values in source)
-- Note    : mason-nvim-dap (configured in manager.lua) handles adapter
--           auto-setup; JS/TS adapters use pwa-node/pwa-chrome from
--           js-debug-adapter (installed via Mason)
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
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
							---@return thread
							url = function()
								local co = coroutine.running()
								return coroutine.create(function()
									vim.ui.input({
										prompt = "Enter URL: ",
										default = "http://localhost:3000",
										---@param url string?
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

				-- ── Python (debugpy) ──────────────────────────────────────────
				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						---@return string
						pythonPath = function()
							local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
							if venv then
								return venv .. "/bin/python"
							end
							return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
						end,
					},
					{
						type = "python",
						request = "launch",
						name = "Launch file with arguments",
						program = "${file}",
						args = function()
							local args_str = vim.fn.input("Arguments: ")
							return vim.split(args_str, " ", { trimempty = true })
						end,
						---@return string
						pythonPath = function()
							local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
							if venv then
								return venv .. "/bin/python"
							end
							return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
						end,
					},
					{
						type = "python",
						request = "attach",
						name = "Attach remote (debugpy)",
						connect = function()
							local host = vim.fn.input("Host [127.0.0.1]: ")
							host = host ~= "" and host or "127.0.0.1"
							local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
							return { host = host, port = port }
						end,
					},
					{
						name = "----- ↓ launch.json configs ↓ -----",
						type = "",
						request = "launch",
					},
				}

				-- ── Rust / C / C++ (codelldb) ──────────────────────────────────
				for _, language in ipairs({ "rust", "c", "cpp" }) do
					dap.configurations[language] = {
						{
							name = "Launch executable",
							type = "codelldb",
							request = "launch",
							program = function()
								return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
							end,
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
							args = {},
						},
						{
							name = "Launch executable (with args)",
							type = "codelldb",
							request = "launch",
							program = function()
								return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
							end,
							args = function()
								local args_str = vim.fn.input("Arguments: ")
								return vim.split(args_str, " ", { trimempty = true })
							end,
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
						},
						{
							name = "Attach to process",
							type = "codelldb",
							request = "attach",
							pid = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
						{
							name = "----- ↓ launch.json configs ↓ -----",
							type = "",
							request = "launch",
						},
					}
				end

				-- ── Bash (bash-debug-adapter) ──────────────────────────────────
				local mason_path = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension"
				dap.configurations.sh = {
					{
						name = "Launch Bash file",
						type = "bashdb",
						request = "launch",
						showDebugOutput = true,
						pathBashdb = mason_path .. "/bashdb_dir/bashdb",
						pathBashdbLib = mason_path .. "/bashdb_dir",
						trace = true,
						file = "${file}",
						program = "${file}",
						cwd = "${workspaceFolder}",
						pathCat = "cat",
						pathBash = "/bin/bash",
						pathMkfifo = "mkfifo",
						pathPkill = "pkill",
						args = {},
						env = {},
						terminalKind = "integrated",
					},
				}

				-- ── PHP (php-debug-adapter / Xdebug) ──────────────────────────
				dap.configurations.php = {
					{
						name = "Listen for Xdebug (port 9003)",
						type = "php",
						request = "launch",
						port = 9003,
						stopOnEntry = false,
						pathMappings = {
							["/var/www/html"] = "${workspaceFolder}",
						},
					},
					{
						name = "Launch currently open script",
						type = "php",
						request = "launch",
						program = "${file}",
						cwd = "${fileDirname}",
						port = 0,
						runtimeArgs = { "-dxdebug.start_with_request=yes" },
						env = {
							XDEBUG_MODE = "debug,develop",
							XDEBUG_CONFIG = "client_port=${port}",
						},
					},
				}

				-- ── Kotlin (kotlin-debug-adapter) ──────────────────────────────
				dap.configurations.kotlin = {
					{
						type = "kotlin",
						request = "launch",
						name = "Launch Kotlin project",
						projectRoot = "${workspaceFolder}",
						mainClass = function()
							return vim.fn.input("Main class (e.g. com.example.MainKt): ", "MainKt")
						end,
					},
				}
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
				---@param variable table
				---@param buf integer
				---@param stackframe table
				---@param node table
				---@param options table
				---@return string
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
