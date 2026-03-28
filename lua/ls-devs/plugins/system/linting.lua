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
		-- Override markdownlint-cli2 args to inject a config that disables
		-- MD013 (line-length) and MD060 (table-column-style) globally.
		-- markdownlint-cli2 reads stdin ("-") but also accepts --config; we write
		-- the JSON once to a temp file so the arg is always available.
		linters = {
			["markdownlint-cli2"] = {
				args = (function()
					local cfg = vim.fn.stdpath("cache") .. "/markdownlint-cli2.json"
					if vim.fn.filereadable(cfg) == 0 then
						vim.fn.writefile(
							{ '{"default":true,"MD013":false,"MD060":false,"MD040":false,"MD022":false,"MD032":false}' },
							cfg
						)
					end
					return { "--config", cfg, "-" }
				end)(),
			},
		},
		linters_by_ft = {
			-- eslint_d: fast daemon designed for linting/diagnostics.
			-- The eslint LSP is configured to suppress publishDiagnostics so it
			-- only provides code actions (Fix all, inline fixes) without duplication.
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			vue = { "eslint_d" },
			astro = { "eslint_d" },
			html = { "djlint" },
			json = { "jsonlint" },
			python = { "ruff" },
			yaml = { "yamllint" },
			dockerfile = { "hadolint" },
			gitcommit = { "gitlint" },
			-- sqlfluff removed: sql-formatter (conform) handles all style/layout
			-- rules on save, and sqlls (LSP) provides syntax checking. sqlfluff
			-- was producing redundant noise (uppercase keywords, linebreak rules).
			sh = { "shellcheck" },
			ps1 = { "psscriptanalyzer" },
			psm1 = { "psscriptanalyzer" },
			psd1 = { "psscriptanalyzer" },
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

		-- psscriptanalyzer: nvim-lint has no built-in definition, so we define one here.
		-- The PSScriptAnalyzer module is bundled inside the powershell-editor-services
		-- Mason package, so no separate install is needed.
		-- -ExecutionPolicy Bypass is required on WSL where pwsh.exe sees the Linux
		-- filesystem as a UNC path (\\wsl.localhost\...) and the Windows policy blocks it.
		local ps_cmd = vim.fn.executable("pwsh") == 1 and "pwsh"
			or vim.fn.executable("pwsh.exe") == 1 and "pwsh.exe"
			or vim.fn.executable("powershell.exe") == 1 and "powershell.exe"
			or nil
		local pssa_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services/PSScriptAnalyzer"
		if ps_cmd and vim.uv.fs_stat(pssa_path) then
			nvim_lint.linters.psscriptanalyzer = {
				name = "psscriptanalyzer",
				cmd = ps_cmd,
				stdin = false,
				append_fname = false,
				args = {
					"-NoLogo",
					"-NonInteractive",
					"-ExecutionPolicy",
					"Bypass",
					"-Command",
					function()
						local fname = vim.api.nvim_buf_get_name(0):gsub("'", "''")
						local mod = pssa_path:gsub("'", "''")
						return string.format(
							"Import-Module '%s';"
								.. " Invoke-ScriptAnalyzer -Path '%s'"
								.. " -Severity @('Error','Warning','Information')"
								.. " | ForEach-Object {"
								.. " Write-Output ('{0}:{1}:{2}:{3}:{4}'"
								.. " -f $_.Severity,$_.Line,$_.Column,$_.RuleName,$_.Message) }",
							mod,
							fname
						)
					end,
				},
				stream = "stdout",
				ignore_exitcode = true,
				parser = function(output, _bufnr)
					local diagnostics = {}
					local sev_map = {
						Error = vim.diagnostic.severity.ERROR,
						Warning = vim.diagnostic.severity.WARN,
						Information = vim.diagnostic.severity.INFO,
						ParseError = vim.diagnostic.severity.ERROR,
					}
					for line in output:gmatch("[^\r\n]+") do
						local sev, lnum, col, rule, msg = line:match("^(%w+):(%d+):(%d+):([^:]+):(.+)$")
						if sev and lnum then
							table.insert(diagnostics, {
								lnum = tonumber(lnum) - 1,
								col = tonumber(col) - 1,
								message = msg,
								source = "psscriptanalyzer",
								code = rule,
								severity = sev_map[sev] or vim.diagnostic.severity.WARN,
							})
						end
					end
					return diagnostics
				end,
			}
		end

		local function lint()
			-- Skip non-normal buffers (hover floats, quickfix, terminal, etc.)
			-- to prevent linters like markdownlint firing on lspsaga hover docs.
			if vim.bo.buftype ~= "" then
				return
			end
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
		---@return fun()
		local function debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function()
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
