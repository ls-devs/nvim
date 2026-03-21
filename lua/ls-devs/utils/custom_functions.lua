---@diagnostic disable: undefined-global
-- ── utils/custom_functions ───────────────────────────────────────────────
-- Purpose : Shared utility functions used across plugin specs and keymaps.
-- Trigger : Required on-demand by plugin configs (not loaded at startup)
-- Provides: HelpGrep, LazyGit, CustomHover, OpenURLs, DiffviewToggle, OrigamiHLFolds
-- ─────────────────────────────────────────────────────────────────────────
local M = {}
--- Opens a `:helpgrep` prompt and displays matching help topics in a new tab.
--- The quickfix list is opened automatically when results are found.
--- Returns silently if the user cancels or provides an empty input.
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

--- Opens lazygit in a centred floating terminal window (150×40) via toggleterm.
--- The float is positioned using the current UI dimensions at call time.
--- `<Esc>` inside the terminal sends `:exit` to close lazygit cleanly.
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

--- Smart hover dispatcher that checks context before acting:
---   1. nvim-ufo fold peek — if the cursor is on a closed fold, peek into it.
---   2. Vim/help filetype  — open the Vim help page for the word under cursor.
---   3. Man filetype       — open the man page for the word under cursor.
---   4. Default            — invoke the LSP hover handler.
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

--- Opens `url` in the default system browser using the platform-appropriate command:
--- `open` (macOS), `wslview` (WSL), `xdg-open` (Linux), or `start` (Windows).
---@param url string The URL to open
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

--- Toggles diffview.nvim: opens a Diffview if none is currently active,
--- or closes the current one. Uses diffview's internal library to detect an open view.
M.DiffviewToggle = function()
	local lib = require("diffview.lib")
	local view = lib.get_current_view()
	if view then
		vim.cmd(":DiffviewClose")
	else
		vim.cmd(":DiffviewOpen")
	end
end

--- Returns fold-aware `h` and `l` motion functions (logic adapted from nvim-origami).
---
--- `h` behaviour (per repeat when a count is given):
---   - cursor past first non-blank col   : normal `h`
---   - cursor at first non-blank col, fold open : close the fold with `zc`
---   - cursor at col 0, inside a fold    : jump to first non-blank of the line above (`k^`)
---   - cursor at col 0, no fold          : normal `h`
---
--- `l` behaviour (per repeat when a count is given):
---   - cursor on a closed fold           : open the fold with `zo`
---   - cursor at end-of-line, in a fold  : jump to first non-blank of the line below (`j^`)
---   - otherwise                         : normal `l`
---
--- Both honour `vim.v.count1` so count-prefixed motions (e.g. `3h`, `5l`) work correctly.
---@return function h, function l
-- h/l folds from nvim-origami as custom functions
M.OrigamiHLFolds = function()
	-- helper
	local function normal(cmdStr)
		vim.cmd.normal({ cmdStr, bang = true })
	end

	-- `h` closes folds when at the beginning of a line.
	-- When inside a fold and already at col 0, jumps to first non-blank of the line above.
	local h = function()
		local count = vim.v.count1
		for _ = 1, count, 1 do
			local col = vim.api.nvim_win_get_cursor(0)[2]
			local line = vim.api.nvim_get_current_line()
			local first_char_col = (line:find("%S") or 1) - 1 -- 0-indexed

			if col == 0 then
				local foldlevel = vim.fn.foldlevel(".")
				if foldlevel > 0 then
					normal("k^")
				else
					normal("h")
				end
			elseif col <= first_char_col then
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
	end

	-- `l` on a folded line opens the fold.
	-- When inside a fold and at end of line, jumps to first non-blank of the line below.
	local l = function()
		local count = vim.v.count1
		for _ = 1, count, 1 do
			local foldclosed = vim.fn.foldclosed(".")
			if foldclosed > -1 then
				pcall(normal, "zo")
			else
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local line = vim.api.nvim_get_current_line()
				if col >= #line - 1 then
					local foldlevel = vim.fn.foldlevel(".")
					if foldlevel > 0 then
						normal("j^")
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
