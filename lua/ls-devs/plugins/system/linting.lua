-- ── nvim-lint ─────────────────────────────────────────────────────────────
-- Purpose : On-demand linter runner, dispatches per-filetype linters
-- Trigger : BufReadPost, BufNewFile (load); BufWritePost/BufReadPost/InsertLeave (run)
-- Note    : codespell is toggled dynamically via <leader>cs in core/keymaps.lua
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			html = { "djlint" },
			htmldjango = { "djlint" },
			json = { "jsonlint" },
			python = { "ruff" },
			yaml = { "yamllint" },
			kotlin = { "ktlint" },
			dockerfile = { "hadolint" },
			gitcommit = { "gitlint" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			cmake = { "cmakelint" },
			sql = { "sqlfluff" },
			sh = { "shellcheck" },
			markdown = { "markdownlint-cli2" },
			css = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			less = { "stylelint" },
			-- lua: lua_ls (LSP) already provides full static analysis including
			-- undefined-global detection, type checking and more. luacheck is
			-- redundant here and produces noisy duplicate/conflicting warnings.
			-- lua = { "luacheck" },
			["*"] = { "codespell" }, -- runs on every filetype; toggle off via <leader>cs
		},
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		local M = {}

		local nvim_lint = require("lint")

		-- sqlfluff: inject --dialect ansi as default so it works without a .sqlfluff project config.
		-- Projects that have a .sqlfluff file can override the dialect there.
		local sqlfluff = nvim_lint.linters.sqlfluff
		if sqlfluff then
			local base_args = vim.list_extend({ "--dialect", "ansi" }, sqlfluff.args or {})
			nvim_lint.linters.sqlfluff = vim.tbl_deep_extend("force", sqlfluff, { args = base_args })
		end

		if opts.linters then
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(nvim_lint.linters[name]) == "table" then
					nvim_lint.linters[name] = vim.tbl_deep_extend("force", nvim_lint.linters[name], linter)
				else
					nvim_lint.linters[name] = linter
				end
			end
		end

		if opts.linters_by_ft then
			nvim_lint.linters_by_ft = opts.linters_by_ft
		end

		local function lint()
			local names = nvim_lint._resolve_linter_by_ft(vim.bo.filetype)

			if #names == 0 then
				vim.list_extend(names, nvim_lint.linters_by_ft["_"] or {}) -- fallback linters for any filetype with no explicit mapping
			end

			vim.list_extend(names, nvim_lint.linters_by_ft["*"] or {}) -- global linters that run on every filetype

			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = nvim_lint.linters[name]
				if not linter then
					vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
				end
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			if #names > 0 then
				nvim_lint.try_lint(names)
			end
		end

		---@param ms integer
		---@param fn fun()
		---@return fun(...)
		local function debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule(fn)
				end)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, lint), -- 100 ms debounce prevents thrashing on rapid buffer events
		})
	end,
}
