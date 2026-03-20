---@diagnostic disable: undefined-global
local M = {}
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
	local gwidth = vim.api.nvim_list_uis()[1].width
	local width = 150
	local height = 40
	local gheight = vim.api.nvim_list_uis()[1].height
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		float_opts = {
			border = "rounded",
			width = width,
			height = height,
			row = (gheight - height) * 0.5,
			column = (gwidth - width) * 0.5,
		},
		on_open = function(term)
			local keymap = vim.api.nvim_buf_set_keymap
			keymap(term.bufnr, "t", "<esc>", "<cmd>exit<CR>", { noremap = true, silent = true })
		end,
	})
	return lazygit:toggle()
end

M.CustomHover = function()
	local ok, ufo = pcall(require, "ufo")
	local winid = ok and ufo.peekFoldedLinesUnderCursor()
	if winid then
		return
	end
	local ft = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, ft) then
		return vim.cmd("silent! h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, ft) then
		return vim.cmd("silent! Man " .. vim.fn.expand("<cword>"))
	else
		return vim.lsp.buf.hover()
	end
end

M.OpenURLs = function(url)
	local opener
	if vim.fn.has("macunix") == 1 then
		opener = "open"
	elseif vim.fn.has("wsl") == 1 then
		opener = "wslview"
	elseif vim.fn.has("linux") == 1 and vim.fn.has("wsl") == 0 then
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

-- h/l folds from nvim-origami as custom functions
M.OrigamiHLFolds = function()
	-- helper
	local function normal(cmdStr)
		vim.cmd.normal({ cmdStr, bang = true })
	end

	-- `h` closes folds when at the beginning of a line.
	local h = function()
		local count = vim.v.count1
		for _ = 1, count, 1 do
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local line = vim.api.nvim_get_current_line()
			-- Trouve la position du premier caractère non-blanc
			local first_char_col = line:find("%S") or 1
			first_char_col = first_char_col - 1 -- convertit en 0-indexé

			if col <= first_char_col then
				local foldlevel = vim.fn.foldlevel(".")
				local foldclosed = vim.fn.foldclosed(".")
				if foldclosed > -1 then
					normal("h")
				elseif foldlevel > 0 then
					local ok = pcall(normal, "zc")
					if not ok then
						normal("h")
					end
				else
					normal("h")
				end
			else
				normal("h")
			end
		end
	end -- `l` on a folded line opens the fold.
	local l = function()
		local count = vim.v.count1
		for _ = 1, count, 1 do
			local foldclosed = vim.fn.foldclosed(".")
			if foldclosed > -1 then
				-- Sur un fold fermé : ouvre le fold
				pcall(normal, "zo")
			else
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local line = vim.api.nvim_get_current_line()
				if col >= #line - 1 then
					-- En fin de ligne : descend au fold enfant si existant
					local next_foldlevel = vim.fn.foldlevel(vim.fn.line(".") + 1)
					local cur_foldlevel = vim.fn.foldlevel(".")
					if next_foldlevel > cur_foldlevel then
						pcall(normal, "j")
					else
						pcall(normal, "l")
					end
				else
					pcall(normal, "l")
				end
			end
		end
	end
	return h, l
end

return M
