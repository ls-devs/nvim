-- ── rustaceanvim ─────────────────────────────────────────────────────────
-- Purpose : Enhanced Rust LSP — replaces plain rust_analyzer with hover
--           actions, macro expansion, runnables/debuggables, and automatic
--           codelldb DAP wiring.
-- Trigger : ft = rust (plugin manages the LSP lifecycle; mason-lspconfig
--           automatic_enable excludes rust_analyzer to avoid conflict)
-- Note    : rust_analyzer is excluded from mason-lspconfig automatic_enable
--           (see manager.lua). codelldb DAP adapter is from Mason.
--           Formatting delegated to rustfmt via conform.nvim.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	ft = "rust",
	---@type RustaceanOpts
	opts = {
		tools = {
			-- All floating windows use rounded borders to match the UI theme
			float_win_config = {
				border = "rounded",
				auto_focus = true,
			},
			hover_actions = {
				replace_builtin_hover = true,
			},
			code_actions = {
				ui_select_fallback = true,
			},
		},
		server = {
			---@param client vim.lsp.Client
			on_attach = function(client)
				-- Formatting delegated to rustfmt via conform.nvim
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			default_settings = {
				["rust-analyzer"] = {
					diagnostics = { enable = true },
					checkOnSave = {
						-- clippy provides richer lints than cargo check
						command = "clippy",
					},
					imports = {
						granularity = { group = "module" },
						prefix = "self",
					},
					cargo = {
						allFeatures = true,
						buildScripts = { enable = true },
					},
					procMacro = {
						enable = true,
						ignored = {
							["async-trait"] = { "async_trait" },
							["napi-derive"] = { "napi" },
							["async-recursion"] = { "async_recursion" },
						},
					},
					inlayHints = {
						lifetimeElisionHints = {
							enable = "skip_trivial",
							useParameterNames = true,
						},
						closureReturnTypeHints = { enable = "with_block" },
					},
				},
			},
		},
		-- ── DAP (codelldb via Mason) ──────────────────────────────────────
		dap = {
			adapter = (function()
				local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
				local codelldb_bin = codelldb_path .. "/adapter/codelldb"
				local liblldb = codelldb_path .. "/lldb/lib/liblldb.so"
				if vim.fn.has("mac") == 1 then
					liblldb = codelldb_path .. "/lldb/lib/liblldb.dylib"
				end
				if vim.fn.executable(codelldb_bin) == 1 then
					return {
						type = "server",
						port = "${port}",
						host = "127.0.0.1",
						executable = {
							command = codelldb_bin,
							args = { "--liblldb", liblldb, "--port", "${port}" },
						},
					}
				end
				-- Fallback: rely on mason-nvim-dap auto-registration
				return nil
			end)(),
		},
	},
	---@param _ LazyPlugin
	---@param opts RustaceanOpts
	config = function(_, opts)
		vim.g.rustaceanvim = opts
	end,
	keys = {
		{
			"K",
			function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end,
			desc = "Rust Hover Actions",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Ra",
			function()
				vim.cmd.RustLsp("codeAction")
			end,
			desc = "Rust Code Action",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Rr",
			function()
				vim.cmd.RustLsp("runnables")
			end,
			desc = "Rust Runnables",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Rd",
			function()
				vim.cmd.RustLsp("debuggables")
			end,
			desc = "Rust Debuggables",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Re",
			function()
				vim.cmd.RustLsp("expandMacro")
			end,
			desc = "Rust Expand Macro",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Rm",
			function()
				vim.cmd.RustLsp("moveItemDown")
			end,
			desc = "Rust Move Item Down",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>RM",
			function()
				vim.cmd.RustLsp("moveItemUp")
			end,
			desc = "Rust Move Item Up",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Roc",
			function()
				vim.cmd.RustLsp("openCargo")
			end,
			desc = "Rust Open Cargo.toml",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Rod",
			function()
				vim.cmd.RustLsp("openDocs")
			end,
			desc = "Rust Open Docs",
			ft = "rust",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Rj",
			function()
				vim.cmd.RustLsp("joinLines")
			end,
			desc = "Rust Join Lines",
			ft = "rust",
			noremap = true,
			silent = true,
		},
	},
}
