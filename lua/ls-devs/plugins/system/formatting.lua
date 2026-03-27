-- ── conform ───────────────────────────────────────────────────────────────
-- Purpose : Code formatter dispatcher — delegates to per-filetype formatters
-- Trigger : BufWritePre (load), ConformInfo cmd; manual format via <leader>fm
-- Note    : format_on_save=false is intentional — use <leader>fm to format manually
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
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
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			vue = { "prettierd" },
			astro = { "prettierd" },
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
			lua = { "stylua" },
			cs = { "csharpier" },
			sql = { "sql_formatter" },
			sh = { "shellharden" },
			-- dockerfile-language-server provides formatting via LSP fallback
			dockerfile = {},
			python = { "black" },
			swift = { "swift-format" },
			ps1 = { "psscriptanalyzer" },
			psm1 = { "psscriptanalyzer" },
			psd1 = { "psscriptanalyzer" },
			["_"] = { "trim_whitespace" }, -- fallback: trim trailing whitespace on any unmatched filetype
		},
		-- Per-formatter defaults applied only when no project config file is found.
		-- Project config files (stylua.toml, .prettierrc, etc.) always take priority.
		formatters = {
			stylua = {
				prepend_args = function(_, ctx)
					if
						#vim.fs.find(
							{ "stylua.toml", ".stylua.toml" },
							{ path = ctx.dirname, upward = true, type = "file" }
						) == 0
					then
						return {
							"--indent-type",
							"Tabs",
							"--indent-width",
							"1",
							"--column-width",
							"120",
							"--quote-style",
							"AutoPreferDouble",
						}
					end
					return {}
				end,
			},
			prettierd = {
				prepend_args = function(_, ctx)
					local configs = {
						".prettierrc",
						".prettierrc.json",
						".prettierrc.js",
						".prettierrc.ts",
						".prettierrc.yaml",
						".prettierrc.yml",
						".prettierrc.toml",
						"prettier.config.js",
						"prettier.config.ts",
						"prettier.config.mjs",
						"prettier.config.cjs",
					}
					if #vim.fs.find(configs, { path = ctx.dirname, upward = true, type = "file" }) == 0 then
						return { "--print-width", "100", "--trailing-comma", "all" }
					end
					return {}
				end,
			},
			taplo = {
				prepend_args = function(_, ctx)
					if
						#vim.fs.find(
							{ "taplo.toml", ".taplo.toml" },
							{ path = ctx.dirname, upward = true, type = "file" }
						) == 0
					then
						return {
							"--option",
							"indent_string=  ",
							"--option",
							"column_width=120",
							"--option",
							"array_trailing_comma=true",
							"--option",
							"compact_arrays=false",
						}
					end
					return {}
				end,
			},
			black = {
				prepend_args = function(_, ctx)
					if
						#vim.fs.find(
							{ "pyproject.toml", "setup.cfg", ".black" },
							{ path = ctx.dirname, upward = true, type = "file" }
						) == 0
					then
						return { "--line-length", "88" }
					end
					return {}
				end,
			},
			["sql_formatter"] = {
				prepend_args = function(_, ctx)
					if
						#vim.fs.find({ ".sql-formatter.json" }, { path = ctx.dirname, upward = true, type = "file" })
						== 0
					then
						return {
							"-l",
							"sql",
							"-c",
							'{"keywordCase":"upper","dataTypeCase":"upper","functionCase":"upper","tabWidth":2,"linesBetweenQueries":2}',
						}
					end
					return {}
				end,
			},
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
