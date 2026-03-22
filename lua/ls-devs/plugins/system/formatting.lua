-- ── conform ───────────────────────────────────────────────────────────────
-- Purpose : Code formatter dispatcher — delegates to per-filetype formatters
-- Trigger : BufWritePre (load), ConformInfo cmd; manual format via <leader>fm
-- Note    : format_on_save=false is intentional — use <leader>fm to format manually
-- ─────────────────────────────────────────────────────────────────────────
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_format = "fallback", timeout_ms = 5000 })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	opts = {
		log_level = vim.log.levels.ERROR,
		notify_on_error = true,
		format_on_save = false, -- intentional: use <leader>fm to format manually
		formatters_by_ft = {
			html = { "prettierd" },
			htmldjango = { "djlint" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			astro = { "prettierd" },
			vue = { "prettierd" },
			svelte = { "prettierd" },
			graphql = { "prettierd" },
			mdx = { "prettierd" },
			xml = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			sass = { "prettierd" },
			less = { "prettierd" },
			json = { "prettierd" },
			toml = { "taplo" },
			markdown = { "markdownlint-cli2" },
			yaml = { "yq" },
			kotlin = { "ktlint" },
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
			c = { "clang-format" },
			cs = { "csharpier" },
			cpp = { "clang-format" },
			cmake = { "gersemi" },
			sql = { "sql-formatter" },
			sh = { "shellharden" },
			python = { "black" },
			php = { "php-cs-fixer" },
			prisma = { "prisma" },
			["_"] = { "trim_whitespace" }, -- fallback: trim trailing whitespace on any unmatched filetype
		},
	},
	config = function(_, opts)
		require("conform").setup(vim.tbl_deep_extend("force", opts, {
			formatters = {
				prisma = {
					command = "prisma",
					args = { "format" },
					stdin = false, -- prisma format reads from disk, not stdin
					cwd = require("conform.util").root_file({ "schema.prisma" }),
					require_cwd = true, -- skip formatting if no schema.prisma is found in the project
				},
			},
		}))
	end,
}
