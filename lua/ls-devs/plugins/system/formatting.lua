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
		notify_on_error = false,
		format_on_save = {
			timeout_ms = 5000,
			lsp_fallback = true,
		},
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
			json = {
				"prettierd",
			},
			markdown = {
				"mdformat",
			},
			yaml = {
				"yq",
			},
			lua = {
				"stylua",
			},
			rust = {
				"rustfmt",
			},
			c = { "clang_format" },
			cpp = { "clang_format" },
			cmake = {
				"gersemi",
			},
			sql = {
				"sql_formatter",
			},
			sh = {
				"shellharden",
			},
			python = { "isort", "black" },
			prisma = { "prisma" },
			["_"] = { "trim_whitespace" },
		},
	},
	config = function(_, opts)
		require("conform").setup(vim.tbl_deep_extend("force", opts, {
			formatters = {
				prisma = {
					command = "prisma",
					args = { "format", "--schema=", "$FILENAME" },
					stdin = false,
					cwd = require("conform.util").root_file({ "schema.prisma" }),
					require_cwd = true,
				},
			},
		}))
	end,
}
