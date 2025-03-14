return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 5000 })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		log_level = vim.log.levels.ERROR,
		notify_on_error = true,
		format_on_save = false,
		formatters_by_ft = {
			html = { "prettierd" },
			htmldjango = { "djlint" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			sass = { "prettierd" },
			less = { "prettierd" },
			json = { "prettierd" },
			markdown = { "markdownlint-cli2" },
			yaml = { "yq" },
			kotlin = { "ktlint" },
			lua = { "stylua" },
			rust = { "rustfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			cmake = { "gersemi" },
			sql = { "sql-formatter" },
			sh = { "shellharden" },
			python = { "black" },
			prisma = { "prisma" },
			["_"] = { "trim_whitespace" },
		},
	},
	config = function(_, opts)
		require("conform").setup(vim.tbl_deep_extend("force", opts, {
			formatters = {
				prisma = {
					command = "prisma",
					args = { "format" },
					stdin = false,
					cwd = require("conform.util").root_file({ "schema.prisma" }),
					require_cwd = true,
				},
			},
		}))
	end,
}
