return function()
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

	local languages = require("efmls-configs.defaults").languages()
	languages = vim.tbl_extend("force", languages, {
		html = { djlint, prettier },
		javascript = { eslint, prettier },
		typescript = { eslint, prettier },
		javascriptreact = { eslint, prettier },
		typescriptreact = { eslint, prettier },
		css = { stylelint, prettier },
		scss = { stylelint, prettier },
		less = { stylelint, prettier },
		sass = { stylelint, prettier },
		lua = { require("efmls-configs.formatters.stylua") },
		sql = {
			require("efmls-configs.linters.sqlfluff"),
			require("efmls-configs.formatters.sql-formatter"),
		},
		gitcommit = { require("efmls-configs.linters.gitlint") },
		json = { require("efmls-configs.linters.jq") },
		c = { cpplint, clang_format },
		cpp = { cpplint, clang_format },
		cmake = {
			require("efmls-configs.linters.cmake_lint"),
			require("efmls-configs.formatters.gersemi"),
		},
		docker = {
			require("efmls-configs.linters.hadolint"),
		},
		yaml = {
			require("efmls-configs.linters.yamllint"),
			require("efmls-configs.formatters.yq"),
		},
		mardown = {
			require("efmls-configs.linters.markdownlint"),
			require("efmls-configs.formatters.mdformat"),
		},
		sh = {
			require("efmls-configs.linters.shellcheck"),
			require("efmls-configs.formatters.shellharden"),
		},
	})

	local efmls_config = {
		filetypes = vim.tbl_keys(languages),
		settings = {
			rootMarkers = { ".git/" },
			languages = languages,
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
	}

	require("lsp-zero").extend_lspconfig()
	require("lspconfig").efm.setup(vim.tbl_extend("force", efmls_config, {}))
end
