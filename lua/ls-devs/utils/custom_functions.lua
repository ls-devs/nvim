local M = {}
M.NeotestSetupProject = function()
	vim.ui.select({ "neotest-jest", "neotest-playwright", "neotest-vim-test", "neotest-vitest" }, {
		prompt = "Choose Adapter",
	}, function(choice)
		local neotestDefault = {
			output = {
				enabled = true,
				open_on_run = true,
			},
			output_panel = {
				enabled = true,
				open = "botright split | resize 15",
			},
			library = { plugins = { "neotest" }, types = true },
			discovery = {
				enabled = false,
			},
		}

		vim.ui.input({
			prompt = "Working directory",
			default = vim.fn.getcwd(),
			completion = "dir",
		}, function(input)
			vim.cmd("cd " .. input)
			if choice == "neotest-jest" then
				local jestConf = vim.tbl_deep_extend("force", neotestDefault, {

					adapters = {
						require("neotest-jest")({
							jestCommand = "npm test --",
							jestConfigFile = function()
								local file = vim.fn.expand("%:p")
								if string.find(file, "/packages/") then
									return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
								end

								return vim.fn.getcwd() .. "/jest.config.ts"
							end,
							jest_test_discovery = false,
							env = { CI = true },
							cwd = function()
								local file = vim.fn.expand("%:p")
								if string.find(file, "/packages/") then
									return string.match(file, "(.-/[^/]+/)src")
								end
								return vim.fn.getcwd()
							end,
						}),
					},
				})
				return require("neotest").setup_project(vim.fn.getcwd(), jestConf)
			end
			if choice == "neotest-vitest" then
				local vitestConf = vim.tbl_deep_extend("force", neotestDefault, {
					adapters = {
						require("neotest-vitest"),
					},
				})
				return require("neotest").setup_project(vim.fn.getcwd(), vitestConf)
			end
			if choice == "neotest-playwright" then
				local playwrightConf = vim.tbl_deep_extend("force", neotestDefault, {
					consumers = {
						playwright = require("neotest-playwright.consumers").consumers,
					},
					adapters = {
						require("neotest-playwright").adapter({
							options = {
								persist_project_selection = true,
								enable_dynamic_test_discovery = true,
							},
						}),
					},
				})
				return require("neotest").setup_project(vim.fn.getcwd(), playwrightConf)
			end
			if choice == "neotest-vim-test" then
				local vimTestConf = vim.tbl_deep_extend("force", neotestDefault, {
					adapters = {
						require("neotest-vim-test"),
					},
				})
				return require("neotest").setup_project(vim.fn.getcwd(), vimTestConf)
			end
		end)
	end)
end

M.HelpGrep = function()
	local open_help_tab = function(help_cmd, topic)
		vim.cmd.tabe()
		local winnr = vim.api.nvim_get_current_win()
		vim.cmd("silent! " .. help_cmd .. " " .. topic)
		vim.api.nvim_win_close(winnr, false)
	end

	vim.ui.input({ prompt = "Grep help for: " }, function(input)
		if input == "" or not input then
			return
		end
		open_help_tab("helpgrep", input)
		if #vim.fn.getqflist() > 0 then
			return vim.cmd.copen()
		end
	end)
end

M.LazyGit = function()
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		float_opts = {
			border = "rounded",
			width = 125,
			height = 35,
		},
		on_open = function(term)
			local keymap = vim.api.nvim_buf_set_keymap
			keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
	})
	return lazygit:toggle()
end

M.CustomHover = function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if winid then
		return
	end
	local ft = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, ft) then
		return vim.cmd("silent! h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, ft) then
		return vim.cmd("silent! Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
		return require("crates").show_popup()
	else
		return vim.lsp.buf.hover()
	end
end

local isOpen = false
M.OverseerToggle = function()
	if not isOpen then
		vim.cmd(":OverseerToggle")
		if vim.fn.exists(":WindowsDisableAutowidth") then
			vim.cmd(":WindowsDisableAutowidth")
		end
		vim.cmd(":WindowsEqualize")
		isOpen = true
	else
		vim.cmd(":OverseerToggle")
		if vim.fn.exists(":WindowsEnableAutowidth") then
			vim.cmd(":WindowsEnableAutowidth")
		end
		isOpen = false
	end
end

M.DiffviewToggle = function()
	local lib = require("diffview.lib")
	local view = lib.get_current_view()
	if view then
		vim.cmd(":DiffviewClose")
	else
		vim.cmd(":DiffviewOpen")
	end
end

return M
