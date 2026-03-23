-- ── neotest ───────────────────────────────────────────────────────────────
-- Purpose : Unified test runner UI — run tests under cursor/file/suite,
--           inline pass/fail gutter signs, floating output panel.
-- Trigger : BufReadPost (load), <leader>T* keymaps
-- Adapters : jest (JS/TS/JSX/TSX/Node), vitest, python (pytest), rust (cargo),
--            phpunit (PHP)
-- Note    : Output and summary panels open as floats (border = "rounded").
--           DAP strategy reuses the existing nvim-dap stack.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-neotest/neotest",
	event = { "BufReadPost" },
	dependencies = {
		{ "nvim-neotest/nvim-nio", lazy = true },
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "nvim-treesitter/nvim-treesitter", lazy = true },
		-- ── Adapters ───────────────────────────────────────────────────────
		{ "nvim-neotest/neotest-jest", lazy = true },
		{ "marilari88/neotest-vitest", lazy = true },
		{ "nvim-neotest/neotest-python", lazy = true },
		{ "rouge8/neotest-rust", lazy = true },
		{ "olimorris/neotest-phpunit", lazy = true },
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		-- Adapters must be instantiated objects at setup time (not functions).
		-- Calling require() here (inside config) guarantees the adapter plugins
		-- are already loaded by lazy.nvim before neotest.setup() runs.
		opts.adapters = {
			-- ── Jest (JS/TS/JSX/TSX/Node) ─────────────────────────────────
			require("neotest-jest")({
				jestCommand = "npx jest --no-coverage",
				jestConfigFile = function(file)
					-- vim.fn.* must not be called in a fast (libuv) event context.
					-- Use vim.fs / vim.uv equivalents instead.
					local dir = vim.fs.dirname(vim.fs.normalize(file))
					local found = vim.fs.find(
						{ "jest.config.ts", "jest.config.js", "jest.config.mjs" },
						{ path = dir, upward = true, type = "file", limit = 1 }
					)
					if found and found[1] then
						return found[1]
					end
					return (vim.uv.cwd() or ".") .. "/jest.config.ts"
				end,
				env = { CI = true },
				cwd = function()
					return vim.uv.cwd()
				end,
			}),
			-- ── Vitest (JS/TS/JSX/TSX/Node) ───────────────────────────────
			require("neotest-vitest"),
			-- ── Python (pytest / unittest) ─────────────────────────────────
			require("neotest-python")({
				dap = { justMyCode = false },
				runner = "pytest",
				python = function()
					local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
					if venv then
						return venv .. "/bin/python"
					end
					return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
				end,
			}),
			-- ── Rust (cargo test) ─────────────────────────────────────────
			require("neotest-rust")({
				args = { "--no-capture" },
				dap_adapter = "codelldb",
			}),
			-- ── PHP (phpunit) — only when phpunit binary is present ───────
			-- Skipped in non-PHP projects to avoid "not executable" errors.
			(vim.fn.executable("phpunit") == 1 or vim.fn.executable("vendor/bin/phpunit") == 1) and require(
				"neotest-phpunit"
			) or nil,
		}
		---@diagnostic disable-next-line: missing-fields
		require("neotest").setup(opts)

		-- Virtual-text render order — Neovim draws highest priority LAST (rightmost).
		-- Desired order: search count | neotest errors | gitsigns blame
		--   search(10) → neotest(100) → blame(300).
		-- priority=100 keeps failure messages between search count and blame.
		vim.diagnostic.config({
			virtual_text = {
				prefix = "󰅖 ",
				format = function(d)
					return d.message
				end,
				priority = 100,
			},
		}, vim.api.nvim_create_namespace("neotest"))

		-- ── Output float keybinds ─────────────────────────────────────────
		-- `neotest-output` filetype is set on every output float buffer.
		-- The buffer is a real terminal (open_term), so the user may be in
		-- terminal mode (t) when the float first receives focus. We:
		--   1. Force normal mode on BufEnter so keymaps work immediately.
		--   2. Map keys in both "n" and "t" modes so they are always reachable.
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "neotest-output",
			callback = function(ev)
				local buf = ev.buf
				local o = { buffer = buf, silent = true, noremap = true }

				-- Force normal mode whenever this buffer is entered
				vim.api.nvim_create_autocmd("BufEnter", {
					buffer = buf,
					callback = function()
						local mode = vim.api.nvim_get_mode().mode
						if mode == "t" then
							vim.api.nvim_feedkeys(
								vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
								"n",
								true
							)
						end
					end,
				})

				local esc = "<C-\\><C-N>"
				-- close
				vim.keymap.set("n", "q", "<cmd>close<cr>", vim.tbl_extend("force", o, { desc = "Close output" }))
				vim.keymap.set("t", "q", esc .. "<cmd>close<cr>", vim.tbl_extend("force", o, { desc = "Close output" }))
				-- jump to next / prev failed test (closes float, lands in source)
				vim.keymap.set("n", "]f", function()
					vim.api.nvim_win_close(0, true)
					require("neotest").jump.next({ status = "failed" })
				end, vim.tbl_extend("force", o, { desc = "Next failed test" }))
				vim.keymap.set("t", "]f", esc .. "]f", vim.tbl_extend("force", o, { desc = "Next failed test" }))
				vim.keymap.set("n", "[f", function()
					vim.api.nvim_win_close(0, true)
					require("neotest").jump.prev({ status = "failed" })
				end, vim.tbl_extend("force", o, { desc = "Prev failed test" }))
				vim.keymap.set("t", "[f", esc .. "[f", vim.tbl_extend("force", o, { desc = "Prev failed test" }))
				-- step through failures — close float, land in source
				vim.keymap.set("n", "]t", function()
					vim.api.nvim_win_close(0, true)
					require("neotest").jump.next({ status = "failed" })
				end, vim.tbl_extend("force", o, { desc = "Next failed → close output" }))
				vim.keymap.set(
					"t",
					"]t",
					esc .. "]t",
					vim.tbl_extend("force", o, { desc = "Next failed → close output" })
				)
				vim.keymap.set("n", "[t", function()
					vim.api.nvim_win_close(0, true)
					require("neotest").jump.prev({ status = "failed" })
				end, vim.tbl_extend("force", o, { desc = "Prev failed → close output" }))
				vim.keymap.set("t", "[t", esc .. "[t", vim.tbl_extend("force", o, { desc = "Prev failed → output" }))
			end,
		})
	end,
	opts = {
		-- adapters are instantiated in config() to guarantee plugins are loaded

		-- ── Output / floating panels ──────────────────────────────────────
		output = {
			enabled = true,
			open_on_run = false,
		},
		-- All floats (output popup, diagnostic preview) use rounded borders
		floating = {
			border = "rounded",
			max_height = 0.8,
			max_width = 0.9,
			options = {},
		},

		-- ── Summary panel ─────────────────────────────────────────────────
		summary = {
			animated = true,
			follow = true,
			expand_errors = true,
			open = "botright vsplit | vertical resize 35",
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				expand_all = "e",
				output = "o",
				short = "O",
				attach = "a",
				jumpto = "i",
				stop = "u",
				run = "r",
				debug = "d",
				mark = "m",
				run_marked = "R",
				debug_marked = "D",
				clear_marked = "M",
				target = "t",
				clear_target = "T",
				next_failed = "]f",
				prev_failed = "[f",
				close = "q",
				help = "?",
			},
		},

		-- Disable quickfix integration (trouble.nvim handles diagnostics)
		quickfix = {
			enabled = false,
			open = false,
		},

		-- ── Icons ─────────────────────────────────────────────────────────
		icons = {
			-- ── Tree structure (box-drawing chars — always render) ─────────
			child_indent = "│",
			child_prefix = "├",
			final_child_indent = " ",
			final_child_prefix = "╰",
			non_collapsible = "─",
			collapsed = "─",
			expanded = "╮",
			-- ── Test status (Nerd Font v3 icons) ──────────────────────────
			passed = "󰄬", -- nf-md-check
			failed = "󰅖", -- nf-md-close_box
			running = "󰁚", -- nf-md-loading (static)
			skipped = "󰒡", -- nf-md-debug_step_over
			unknown = "󰘔", -- nf-md-help_circle
			watching = "󰈈", -- nf-md-eye
			test = "󰙨", -- nf-md-test_tube (individual test items)
			notify = "󰔐", -- nf-md-bell
			-- ── Spinner animation frames (braille — universal) ─────────────
			running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
		},

		status = { virtual_text = true, signs = true },

		-- Show the failure message as virtual text at the assertion line.
		-- This uses its own diagnostic namespace so it stays visible even
		-- though virtual_text is globally disabled for LSP diagnostics.
		diagnostic = {
			enabled = true,
			severity = vim.diagnostic.severity.ERROR,
		},

		-- Suppress noisy "no tests found" notifications
		log_level = vim.log.levels.WARN,
	},
	keys = {
		-- ── Run ──────────────────────────────────────────────────────────
		{
			"<leader>Tr",
			function()
				-- run.run() is async — it captures cursor position immediately.
				-- Call it BEFORE summary.open() so the current buffer/cursor
				-- still points at the test file when neotest reads position.
				require("neotest").run.run()
				require("neotest").summary.open()
			end,
			desc = "Neotest Run Nearest",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Tf",
			function()
				require("neotest").run.run(vim.fn.expand("%:p"))
				require("neotest").summary.open()
			end,
			desc = "Neotest Run File",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Ts",
			function()
				local nt = require("neotest")
				nt.summary.open()
				-- Poll until at least one adapter has discovered tests
				-- (status_counts.total > 0). This guards against running adapters
				-- that are registered but have no matching files in this project
				-- (e.g. phpunit / pytest in a JS project), which would produce
				-- spurious errors. Give up after ~3 s and fall back to cwd.
				local attempts = 0
				local function try_run()
					local ids = nt.state.adapter_ids()
					local runnable = {}
					for _, id in ipairs(ids) do
						local counts = nt.state.status_counts(id)
						if counts and counts.total > 0 then
							table.insert(runnable, id)
						end
					end
					if #runnable > 0 then
						for _, id in ipairs(runnable) do
							nt.run.run({ suite = true, adapter = id })
						end
					elseif attempts < 30 then
						attempts = attempts + 1
						vim.defer_fn(try_run, 100)
					else
						nt.run.run(vim.fn.getcwd())
					end
				end
				try_run()
			end,
			desc = "Neotest Run Suite",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Td",
			function()
				require("neotest").summary.open()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Neotest Debug Nearest",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Tx",
			function()
				require("neotest").run.stop()
			end,
			desc = "Neotest Stop",
			noremap = true,
			silent = true,
		},
		-- ── Output / panels ───────────────────────────────────────────────
		{
			"<leader>To",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Neotest Output Float",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Tp",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Neotest Summary Panel",
			noremap = true,
			silent = true,
		},
		-- ── Jump to failed tests ─────────────────────────────────────────
		{
			"]t",
			function()
				require("neotest").jump.next({ status = "failed" })
			end,
			desc = "Neotest Next Failed",
			noremap = true,
			silent = true,
		},
		{
			"[t",
			function()
				require("neotest").jump.prev({ status = "failed" })
			end,
			desc = "Neotest Prev Failed",
			noremap = true,
			silent = true,
		},
	},
}
