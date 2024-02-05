return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function()
		require("lint").linters_by_ft = {
			html = { "djlint" },
			css = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			less = { "stylelint" },
			json = { "jsonlint" },
			dockerfile = { "hadolint" },
			markdown = { "markdownlint" },
			yaml = { "yamllint" },
			gitcommit = { "gitlint" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			cmake = { "cmake-lint" },
			sql = { "sqlfluff" },
			sh = { "shellcheck" },
		}
	end,
}
