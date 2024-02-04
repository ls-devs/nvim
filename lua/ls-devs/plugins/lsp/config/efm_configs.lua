local M = {}

-- Utils and Defaults
local fs = require("efmls-configs.fs")
local languages = require("efmls-configs.defaults").languages()

-- JS / TS
local eslint = require("efmls-configs.linters.eslint")
local prettier = require("efmls-configs.formatters.prettier")

-- CSS / SCSS / LESS / SASS
local stylelint = require("efmls-configs.linters.stylelint")

-- HTML
local djlint = require("efmls-configs.linters.djlint")

-- C / CPP
local cpplint = require("efmls-configs.linters.cpplint")
local clang_format = require("efmls-configs.formatters.clang_format")

-- Prisma

M.languages = vim.tbl_extend("force", languages, {
	html = { djlint, prettier },
	javascript = { eslint, prettier },
	javascriptreact = { eslint, prettier },
	typescript = { eslint, prettier },
	typescriptreact = { eslint, prettier },
	css = { stylelint, prettier },
	scss = { stylelint, prettier },
	sass = { stylelint, prettier },
	less = { stylelint, prettier },
	json = {
		require("efmls-configs.linters.jq"),
		prettier,
	},
	prisma = {
		string.format("format '${FILENAME}'", fs.executable("prisma", "NODE")),
	},
	docker = {
		require("efmls-configs.linters.hadolint"),
	},
	mardown = {
		require("efmls-configs.linters.markdownlint"),
		require("efmls-configs.formatters.mdformat"),
	},
	yaml = {
		require("efmls-configs.linters.yamllint"),
		require("efmls-configs.formatters.yq"),
	},
	gitcommit = {
		require("efmls-configs.linters.gitlint"),
	},
	lua = {
		require("efmls-configs.formatters.stylua"),
	},
	c = { cpplint, clang_format },
	cpp = { cpplint, clang_format },
	cmake = {
		require("efmls-configs.linters.cmake_lint"),
		require("efmls-configs.formatters.gersemi"),
	},
	sql = {
		require("efmls-configs.linters.sqlfluff"),
		require("efmls-configs.formatters.sql-formatter"),
	},
	sh = {
		require("efmls-configs.linters.shellcheck"),
		require("efmls-configs.formatters.shellharden"),
	},
})

return M
