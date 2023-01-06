local mason_null_ls = require("mason-null-ls")

if not mason_null_ls then
	return
end

local null_ls = require("null-ls")

if not null_ls then
	return
end

mason_null_ls.setup({
	automatic_installation = true,
	ensure_installed = {
		"black",
		"stylua",
		"luacheck",
		"eslint_d",
		"prettierd",
		"rustfmt",
		"prismaFmt",
		"cmakelang",
		"markdownlint",
		"yamllint",
		"yamlfmt",
		"jsonlint",
		"jq",
		"phpcs",
		"php-cs-fixer",
		"proselint",
		"refactoring",
		"hadolint",
	},
})

--luacheck: ignore augroup
---@diagnostic disable-next-line: unused-local
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	border = "rounded",
	sources = {
		-- PYTHON
		null_ls.builtins.code_actions.refactoring.with({
			filetypes = { "python" },
		}),
		null_ls.builtins.formatting.black,
		-- JS / TS
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.prettierd,
		-- JSON
		null_ls.builtins.diagnostics.jsonlint,
		null_ls.builtins.formatting.jq,
		-- LUA
		null_ls.builtins.code_actions.refactoring.with({
			filetypes = { "lua" },
		}),
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.formatting.stylua,
		-- PRISMA
		null_ls.builtins.formatting.prismaFmt,
		-- RUST
		null_ls.builtins.formatting.rustfmt,
		-- CMAKE
		null_ls.builtins.diagnostics.cmake_lint,
		null_ls.builtins.formatting.cmake_format,
		-- MARKDOWN
		null_ls.builtins.code_actions.proselint,
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.formatting.markdownlint,
		-- YAML
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.yamlfmt,
		-- PHP
		null_ls.builtins.diagnostics.phpcs,
		null_ls.builtins.formatting.phpcsfixer,
		-- DOCKER
		null_ls.builtins.diagnostics.hadolint,
	},
})
