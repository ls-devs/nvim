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
		"prettier",
    "rustfmt",
    "black",
    "prismaFmt"
	},
})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prismaFmt,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.rustfmt,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
