return {
	"simrat39/rust-tools.nvim",
	event = { "BufReadPost *.rs" },
	dependencies = { { "nvim-lua/plenary.nvim" } },
	opts = {
		tools = {
			runnables = {
				use_telescope = true,
			},
			inlay_hints = { auto = true, show_parameter_hints = true, locationLinks = false },
			hover_actions = { auto_focus = true },
		},

		server = {
			standalone = true,
			["rust-analyzer"] = {
				inlayHints = { auto = true, show_parameter_hints = true },
				lens = {
					enable = true,
				},
				checkonsave = {
					command = "clippy",
				},
				procMacros = {
					enabled = true,
				},
			},
		},
	},
	config = function(_, opts)
		local mason_registry = require("mason-registry")
		local codelldb = mason_registry.get_package("codelldb")
		local extension_path = codelldb:get_install_path() .. "/extension/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
			or extension_path .. "lldb/lib/liblldb.so"
		local rt = require("rust-tools")
		rt.setup(vim.tbl_extend("force", opts, {
			server = {
				on_attach = function(_, bufnr)
					vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
					vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
				end,
			},
			dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
			},
		}))
	end,
}
