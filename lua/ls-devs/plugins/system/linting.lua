return {
	event = "BufReadPost",
	"mfussenegger/nvim-lint",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			html = { "djlint" },
			htmldjango = { "djlint" },
			css = { "stylelint" },
			scss = { "stylelint" },
			sass = { "stylelint" },
			less = { "stylelint" },
			json = { "jsonlint" },
			markdown = { "markdownlint" },
			yaml = { "yamllint" },
			dockerfile = { "hadolint" },
			gitcommit = { "gitlint" },
			c = { "cpplint" },
			cpp = { "cpplint" },
			cmake = { "cmakelint" },
			sql = { "sqlfluff" },
			sh = { "shellcheck" },
		},
		linters = {},
	},
	config = function(_, opts)
		local M = {}

		local nvim_lint = require("lint")
		for name, linter in pairs(opts.linters) do
			if type(linter) == "table" and type(nvim_lint.linters[name]) == "table" then
				nvim_lint.linters[name] = vim.tbl_deep_extend("force", nvim_lint.linters[name], linter)
			else
				nvim_lint.linters[name] = linter
			end
		end
		nvim_lint.linters_by_ft = opts.linters_by_ft

		function M.debounce(ms, fn)
			local timer = vim.loop.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end
		function M.lint()
			-- Use nvim-lint's logic first:
			-- * checks if linters exist for the full filetype first
			-- * otherwise will split filetype by "." and add all those linters
			-- * this differs from conform.nvim which only uses the first filetype that has a formatter
			local names = nvim_lint._resolve_linter_by_ft(vim.bo.filetype)

			-- Add fallback linters.
			if #names == 0 then
				vim.list_extend(names, nvim_lint.linters_by_ft["_"] or {})
			end

			-- Add global linters.
			vim.list_extend(names, nvim_lint.linters_by_ft["*"] or {})

			-- Filter out linters that don't exist or don't match the condition.
			local ctx = { filename = vim.api.nvim_buf_get_name(0) }
			ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
			names = vim.tbl_filter(function(name)
				local linter = nvim_lint.linters[name]
				if not linter then
					vim.notify("Linter not found: " .. name, vim.log.levels.WARN)
				end
				return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
			end, names)

			-- Run linters.
			if #names > 0 then
				nvim_lint.try_lint(names)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = M.debounce(100, M.lint),
		})
	end,
}
