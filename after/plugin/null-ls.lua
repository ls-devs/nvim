local mason_null_ls = require("mason-null-ls")

if not mason_null_ls then
	return
end

local null_ls = require("null-ls")

if not null_ls then
	return
end

mason_null_ls.setup({
	automatic_installation = false,
	ensure_installed = {
		"stylua",
		"eslint_d",
		"prettierd",
		"rustfmt",
		"black",
		"prismaFmt",
		"luacheck",
	},
})

--luacheck: ignore augroup
---@diagnostic disable-next-line: unused-local
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	border = "rounded",
	sources = {
		-- PYTHON
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.formatting.black,
		-- JS / TS
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.prettierd,
		-- LUA
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.formatting.stylua,
		-- PRISMA
		null_ls.builtins.formatting.prismaFmt,
		-- RUST
		null_ls.builtins.formatting.rustfmt,
		-- CPP
		null_ls.builtins.diagnostics.cpplint,
		null_ls.builtins.formatting.clang_format,
		-- CMAKE
		null_ls.builtins.diagnostics.cmake_lint,
		null_ls.builtins.formatting.cmake_format,
	},
	--[[ on_attach = function(client, bufnr) ]]
	--[[ 	if client.supports_method("textDocument/formatting") then ]]
	--[[ 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr }) ]]
	--[[ 		vim.api.nvim_create_autocmd("InsertLeave", { ]]
	--[[ 			group = augroup, ]]
	--[[ 			buffer = bufnr, ]]
	--[[ 			callback = function() ]]
	--[[ 				vim.lsp.buf.format({ ]]
	--[[ 					bufnr = bufnr, ]]
	--[[ 					timeout_ms = 2200, ]]
	--[[ 					filter = function() ]]
	--[[ 						return client.name == "null-ls" ]]
	--[[ 					end, ]]
	--[[ 				}) ]]
	--[[ 			end, ]]
	--[[ 		}) ]]
	--[[ 	end ]]
	--[[ end, ]]
})
