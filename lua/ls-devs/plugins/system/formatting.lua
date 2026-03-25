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
			sql = { "sql-formatter" },
			sh = { "shellharden" },
			python = { "black" },
			swift = { "swift-format" },
			["_"] = { "trim_whitespace" }, -- fallback: trim trailing whitespace on any unmatched filetype
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)
	end,
}
