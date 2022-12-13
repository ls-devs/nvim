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
	},
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	border = "rounded",
	sources = {
		null_ls.builtins.diagnostics.pylint,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.diagnostics.cpplint,
		null_ls.builtins.diagnostics.cmake_lint,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prismaFmt,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.clang_format,
		null_ls.builtins.formatting.cmake_format,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("InsertLeave", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
