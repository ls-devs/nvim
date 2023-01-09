return function()
	local mason_null_ls = require("mason-null-ls")
	if not mason_null_ls then
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
end
