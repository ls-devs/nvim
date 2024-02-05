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
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				html = {
					"prettierd",
				},
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
				c = { "clang_format " },
				cpp = { "clang_format " },
				cmake = {
					"gersemi",
				},
				sql = {
					"sqlfluff",
				},
				sh = {
					"shellharden",
				},
				python = { "isort", "black" },
				prisma = { "prisma" },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
				clang_format = {
					command = "clang_format",
				},
				gersemi = {
					command = "gersemi",
				},
				prisma = {
					command = "prisma",
					args = { "format", "--schema=", "$FILENAME" },
					stdin = false,
					cwd = require("conform.util").root_file({ "schema.prisma" }),
					require_cwd = true,
				},
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			init = function()
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			end,
		})
	end,
}
