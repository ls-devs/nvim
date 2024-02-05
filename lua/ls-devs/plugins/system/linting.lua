return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function()
		require("lint").linters_by_ft = {
			html = { "djlint" },
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			css = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			less = { "stylelint" },
			json = { "jsonlint" },
			dockerfile = { "hadolint" },
			markdown = { "markdownlint" },
			yaml = { "yamllint" },
			gitcommit = { "gitlint" },
			lua = { "luacheck" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			cmake = { "cmake-lint" },
			sql = { "sqlfluff" },
			sh = { "shellcheck" },
		}
	end,
}
