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
	local editor_width = vim.o.columns
	local editor_height = vim.o.lines
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		float_opts = {
			border = "rounded",
			width = math.min(125, editor_width),
			height = math.min(35, editor_height),
			col = 10,
			row = math.floor(editor_height * 0.5 - math.min(35, editor_height) * 0.5),
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
	elseif vim.tbl_contains({ "markdown" }, ft) and vim.fn.exists(":ObsidianFollowLink") then
		local has_obsidian, _ = pcall(require, "obsidian")
		if has_obsidian then
			vim.cmd(":ObsidianFollowLink")
		end
	else
		return vim.lsp.buf.hover()
	end
end

M.OpenURLs = function(url)
	local opener
	if vim.fn.has("macunix") == 1 then
		opener = "open"
	elseif vim.fn.has("linux") == 1 then
		opener = "xdg-open"
	elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
		opener = "start"
	end
	local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
	vim.fn.system(openCommand)
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

M.HarpoonTelescope = function(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return M
