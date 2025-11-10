return {
	event = { "BufReadPost", "BufNewFile" },
	"mfussenegger/nvim-lint",
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			html = { "djlint" },
			htmldjango = { "djlint" },
			-- css = { "stylelint" },
			-- scss = { "stylelint" },
			-- sass = { "stylelint" },
			-- less = { "stylelint" },
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
		},
	},
	config = function(_, opts)
		local M = {}

		local nvim_lint = require("lint")

		if opts.linters then
			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(nvim_lint.linters[name]) == "table" then
					nvim_lint.linters[name] = vim.tbl_deep_extend("force", nvim_lint.linters[name], linter)
				else
					nvim_lint.linters[name] = linter
				end
			end
		end

		-- nvim_lint.linters["cpplint"] = vim.tbl_deep_extend("force", nvim_lint.linters["cpplint"], {
		-- 	-- cmd = require("mason-registry").get_package("cpplint"):get_install_path() .. "/" .. "venv/bin/cpplint",
		-- })

		-- nvim_lint.linters["gitlint"] = vim.tbl_deep_extend("force", nvim_lint.linters["gitlint"], {
		-- 	-- cmd = require("mason-registry").get_package("gitlint"):get_install_path() .. "/" .. "venv/bin/gitlint",
		-- })

		if opts.linters_by_ft then
			nvim_lint.linters_by_ft = opts.linters_by_ft
		end

		local function lint()
			local names = nvim_lint._resolve_linter_by_ft(vim.bo.filetype)

			if #names == 0 then
				vim.list_extend(names, nvim_lint.linters_by_ft["_"] or {})
			end

			vim.list_extend(names, nvim_lint.linters_by_ft["*"] or {})

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

		local function debounce(ms, fn)
			local timer = vim.loop.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = debounce(100, lint),
		})
	end,
}
