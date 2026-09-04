-- ── nvim-dap-view ─────────────────────────────────────────────────────────
-- Purpose : Full DAP debugging ecosystem for Neovim
--
-- Standardized DAP Keymaps (project-agnostic, reusable):
--
--   <leader>uo   Toggle DAP view panel (DapViewToggle)
--   <leader>uc   Close DAP view panel (DapViewClose)
--   <leader>uh   Hover/evaluate expression under cursor or selection
--   <leader>uw   Watch expression under cursor or selection
--   <leader>un   Continue/start debug session (dap.continue)
--   <leader>ut   Terminate debug session (dap.terminate)
--   <leader>bb   Toggle breakpoint (dap.toggle_breakpoint)
--   <leader>dC   Attach Chrome/Arc debugger (custom, WSL-aware)
--   <leader>dN   Attach Node.js/TS debugger (custom, auto ts-node)
--
-- All keymaps are documented with 'desc' and are safe for reuse in other Neovim configs.
--
-- Provides: nvim-dap (protocol client), nvim-dap-view (panels + inline
--           virtual text + hover, all in one plugin)
-- Note    : replaces nvim-dap-ui + nvim-dap-virtual-text, both of which went
--           into low-maintenance mode. nvim-dap-view ships its own virtual
--           text implementation, so the separate plugin is no longer needed,
--           and `auto_toggle` replaces the four manual dap.listeners that
--           used to open/close the panel.
--           mason-nvim-dap (configured in manager.lua) handles adapter
--           auto-setup; JS/TS adapters use pwa-node/pwa-chrome from
--           js-debug-adapter (installed via Mason)
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"igorlfs/nvim-dap-view",
	version = "1.*",
	cmd = {
		"DapViewOpen",
		"DapViewClose",
		"DapViewToggle",
		"DapViewHover",
		"DapViewWatch",
		"DapViewJump",
		"DapViewShow",
		"DapViewNavigate",
		"DapViewVirtualTextEnable",
		"DapViewVirtualTextDisable",
		"DapViewVirtualTextToggle",
	},
	opts = {
		-- Open the panel when a session starts, close it when the session ends.
		-- Replaces the dapui open/close listeners this config used to register.
		auto_toggle = true,
		windows = {
			size = 0.25,
			position = "below",
		},
		winbar = {
			show = true,
			default_section = "scopes",
			sections = { "scopes", "watches", "threads", "breakpoints", "exceptions", "repl", "console" },
			show_keymap_hints = true,
		},
		-- Built-in replacement for nvim-dap-virtual-text, matching the previous
		-- inline placement and " = value" rendering.
		virtual_text = {
			enabled = true,
			position = "inline",
			---@param variable dap.Variable
			---@return string
			format = function(variable)
				return " = " .. variable.value
			end,
		},
		-- Reuse the config-wide rounded borders
		help = { border = "rounded" },
		hover = { border = "rounded" },
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("dap-view").setup(opts)
		local dap = require("dap")

		-- Report the debuggee's exit code (auto_toggle already handles the panel)
		dap.listeners.after.event_exited["dap_view_exit_notify"] = function(_, body)
			local code = body and body.exitCode or "?"
			if code == 0 then
				vim.notify("[DAP] Process exited (code 0)", vim.log.levels.INFO)
			else
				vim.notify("[DAP] Process exited with code " .. tostring(code), vim.log.levels.WARN)
			end
		end

		-- Gutter signs for breakpoint variants
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "✕", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
		)
	end,
	dependencies = {
		{
			"mfussenegger/nvim-dap",
			config = function()
				local dap = require("dap")

				-- ── JS/TS adapters (js-debug-adapter via Mason) ───────────────
				-- mason-nvim-dap automatic_installation only installs the binary;
				-- pwa-node / pwa-chrome must be registered manually.
				local js_debug = vim.fn.stdpath("data")
					.. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = { command = "node", args = { js_debug, "${port}" } },
				}
				dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

				-- js-debug connecting through the WSL relay needs more time than the
				-- default 4s timeout before it responds to the initialize handshake.
				dap.defaults["pwa-chrome"].initialize_timeout_sec = 20
				dap.defaults["pwa-node"].initialize_timeout_sec = 20

				-- ── Lua adapter (one-small-step-for-vimkind / osv) ───────────
				dap.adapters.nlua = function(callback, config)
					callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
				end
				dap.configurations.lua = {
					{
						type = "nlua",
						request = "attach",
						name = "Attach to running Neovim (osv)",
						host = "127.0.0.1",
						port = 8086,
					},
				}

				-- pwa-node / pwa-chrome configs applied to all JS/TS-family filetypes
				for _, language in ipairs({
					"typescript",
					"javascript",
					"typescriptreact",
					"javascriptreact",
				}) do
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							-- Auto-detects file type:
							--   test files  → jest --runInBand (provides describe/it/expect globals)
							--   .ts/.tsx    → node -r ts-node/register
							--   .js/.jsx    → plain node
							-- stopOnEntry=true pauses at the first line so you can see DAP attach
							-- even for fast scripts — remove it if you want to run freely to breakpoints.
							stopOnEntry = true,
							program = function()
								local file = vim.fn.expand("%:p")
								if vim.fn.filereadable(file) == 0 then
									vim.notify("[DAP] Open a JS/TS file first", vim.log.levels.WARN)
									return require("dap").ABORT
								end
								if file:match("%.test%.[jt]sx?$") or file:match("%.spec%.[jt]sx?$") then
									local local_jest = vim.fn.getcwd() .. "/node_modules/.bin/jest"
									if vim.fn.filereadable(local_jest) == 1 then
										return local_jest
									end
								end
								return file
							end,
							args = function()
								local file = vim.fn.expand("%:p")
								if file:match("%.test%.[jt]sx?$") or file:match("%.spec%.[jt]sx?$") then
									return { file, "--no-coverage", "--runInBand" }
								end
								return {}
							end,
							runtimeArgs = function()
								local file = vim.fn.expand("%:p")
								local is_test = file:match("%.test%.[jt]sx?$") or file:match("%.spec%.[jt]sx?$")
								if not is_test and file:match("%.tsx?$") then
									return { "--nolazy", "-r", "ts-node/register" }
								end
								return {}
							end,
							-- Must be a function — evaluated at launch time, not at plugin-load time.
							cwd = function()
								return vim.fn.getcwd()
							end,
							sourceMaps = true,
							resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
							skipFiles = { "<node_internals>/**", "**/node_modules/**" },
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach (pick process)",
							processId = require("dap.utils").pick_process,
							cwd = function()
								return vim.fn.getcwd()
							end,
							sourceMaps = true,
							skipFiles = { "<node_internals>/**", "**/node_modules/**" },
							resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach to Node.js (port 9229)",
							port = function()
								local r = vim.fn.system(
									"bash -c '>/dev/tcp/127.0.0.1/9229' 2>/dev/null && echo ok || echo fail"
								)
								if not r:match("ok") then
									vim.notify(
										"[DAP] Nothing on port 9229.\nStart your app with:\n  node --inspect -r ts-node/register src/main.ts",
										vim.log.levels.WARN
									)
									return require("dap").ABORT
								end
								return 9229
							end,
							cwd = function()
								return vim.fn.getcwd()
							end,
							sourceMaps = true,
							skipFiles = { "<node_internals>/**", "**/node_modules/**" },
							resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
						},
						{
							type = "pwa-chrome",
							request = "attach",
							name = "Attach to Chrome (port 9222)",
							-- Use <leader>dC for automatic WSL Chrome launch.
							-- This config is for when Chrome is already running with --remote-debugging-port=9222.
							port = function()
								local r = vim.fn.system(
									"bash -c '>/dev/tcp/127.0.0.1/9222' 2>/dev/null && echo ok || echo fail"
								)
								if not r:match("ok") then
									vim.notify(
										"[DAP] Chrome CDP port 9222 not open.\nUse <leader>dC to auto-launch Windows Chrome,\nor start Chrome with: --remote-debugging-port=9222",
										vim.log.levels.WARN
									)
									return require("dap").ABORT
								end
								return 9222
							end,
							webRoot = function()
								return vim.fn.getcwd()
							end,
							sourceMaps = true,
							protocol = "inspector",
							urlFilter = "http://localhost:*",
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
				}

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
			end,
			dependencies = {
				{
					"jbyuki/one-small-step-for-vimkind",
					-- <leader>bL starts the Lua DAP server in the current Neovim instance,
					-- then use <leader>bb to attach via the nlua adapter.
					keys = {
						{
							"<leader>bL",
							function()
								require("osv").launch({ port = 8086 })
							end,
							desc = "DAP Launch Lua server (osv)",
						},
					},
				},
				{
					"Joakker/lua-json5",
					build = "./install.sh",
				},
			},
		},
	},
	keys = {
		-- Panel toggle
		{
			"<leader>uo",
			"<cmd>DapViewToggle<CR>",
			desc = "DAP View Toggle",
			noremap = true,
			silent = true,
		},
		{
			"<leader>uc",
			"<cmd>DapViewClose<CR>",
			desc = "DAP View Close",
			noremap = true,
			silent = true,
		},
		-- Evaluate / watch (built into dap-view, no extra plugin needed)
		{
			"<leader>uh",
			"<cmd>DapViewHover<CR>",
			mode = { "n", "x" },
			desc = "DAP Hover Expression",
			noremap = true,
			silent = true,
		},
		{
			"<leader>uw",
			"<cmd>DapViewWatch<CR>",
			mode = { "n", "x" },
			desc = "DAP Watch Expression",
			noremap = true,
			silent = true,
		},
		-- Session control
		{
			"<leader>un",
			"<cmd>DapContinue<cr>",
			desc = "DAP Continue",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ut",
			"<cmd>DapTerminate<cr>",
			desc = "DAP Terminate",
			noremap = true,
			silent = true,
		},
		-- Breakpoints
		{
			"<leader>bb",
			"<cmd>DapToggleBreakpoint<cr>",
			desc = "DAP Toggle Breakpoint",
			noremap = true,
			silent = true,
		},
		-- Step controls
		{
			"<leader>us",
			function()
				require("dap").step_over()
			end,
			desc = "DAP Step Over",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ui",
			function()
				require("dap").step_into()
			end,
			desc = "DAP Step Into",
			noremap = true,
			silent = true,
		},
		{
			"<leader>uu",
			function()
				require("dap").step_out()
			end,
			desc = "DAP Step Out",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ur",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "DAP Run To Cursor",
			noremap = true,
			silent = true,
		},
		-- WSL Chrome debugger (auto-launch Arc + attach)
		{
			"<leader>dC",
			function()
				require("ls-devs.utils.custom_functions").DapChromeDebug()
			end,
			desc = "DAP Arc/Chrome Debug (WSL auto)",
			noremap = true,
			silent = true,
		},
		-- Node.js/TypeScript debugger (auto-detect entry from package.json)
		{
			"<leader>dN",
			function()
				require("ls-devs.utils.custom_functions").DapNodeDebug()
			end,
			desc = "DAP Node Debug (auto ts-node)",
			noremap = true,
			silent = true,
		},
	},
}
