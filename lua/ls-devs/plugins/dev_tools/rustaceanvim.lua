return {
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	init = function()
		vim.g.rustaceanvim = function()
			local mason_registry = require("mason-registry")
			local codelldb = mason_registry.get_package("codelldb")
			local extension_path = codelldb:get_install_path() .. "/extension/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
				or extension_path .. "lldb/lib/liblldb.so"

			local cfg = require("rustaceanvim.config")
			return {
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
			}
		end
	end,
}
