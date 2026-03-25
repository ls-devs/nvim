-- ── snacks/picker.lua ────────────────────────────────────────────────────
-- Picker (replaces telescope.nvim) opts for snacks.lua.
-- Layout: reverse list (best match near prompt), equal 50/50 split,
-- preview wrap=false for horizontal scroll, frecency matcher.
-- <A-f>/<A-b> override snacks default toggle_follow via normkey normalization
-- (both <A-f> and <a-f> resolve to <M-f>, user config wins).
-- <C-f>/<C-b> use custom actions that preserve leftcol: snacks' built-in
-- preview_scroll_down/up use <C-e>/<C-y> which can move the cursor to a
-- shorter line. When the cursor ends up on a line shorter than view.col,
-- Neovim immediately clamps col to line-end; if col_clamped < leftcol it
-- resets leftcol=0 within the same winrestview call, breaking subsequent
-- <A-f>/<A-b> horizontal scroll. The fix scans the new viewport for the
-- first line wide enough to keep col >= leftcol; if none exists the leftcol
-- reset is accepted gracefully (the section genuinely has only short lines).
-- ─────────────────────────────────────────────────────────────────────────
---@type table
return {
	-- snacks replaces vim.ui.select (URL picker in treesitter.lua, etc.)
	ui_select = true,
	-- Magnifying glass (loupe) icon shown left of the search input.
	prompt = "  ",
	actions = {
		---@param picker snacks.Picker
		preview_scroll_down_hpreserve = function(picker)
			local win = picker.preview.win
			if not win:valid() then
				return
			end
			vim.api.nvim_win_call(win.win, function()
				local view = vim.fn.winsaveview()
				local leftcol = view.leftcol
				local h = vim.api.nvim_win_get_height(0)
				local buf_lines = vim.api.nvim_buf_line_count(0)
				view.topline = math.min(view.topline + vim.wo.scroll, buf_lines)
				local new_bottom = math.min(view.topline + h - 1, buf_lines)
				view.lnum = math.max(view.lnum, view.topline)
				view.lnum = math.min(view.lnum, new_bottom)
				if leftcol > 0 then
					-- Find a line in the new viewport wide enough to keep col >= leftcol.
					-- Byte length approximates display width for ASCII/code files.
					-- If no such line exists the leftcol reset is accepted gracefully.
					local lines = vim.api.nvim_buf_get_lines(0, view.topline - 1, new_bottom, false)
					for i, line in ipairs(lines) do
						if #line >= leftcol then
							view.lnum = view.topline + i - 1
							view.col = leftcol
							view.coladd = 0
							break
						end
					end
				end
				vim.fn.winrestview(view)
			end)
		end,
		---@param picker snacks.Picker
		preview_scroll_up_hpreserve = function(picker)
			local win = picker.preview.win
			if not win:valid() then
				return
			end
			vim.api.nvim_win_call(win.win, function()
				local view = vim.fn.winsaveview()
				local leftcol = view.leftcol
				local h = vim.api.nvim_win_get_height(0)
				local buf_lines = vim.api.nvim_buf_line_count(0)
				view.topline = math.max(view.topline - vim.wo.scroll, 1)
				local new_bottom = math.min(view.topline + h - 1, buf_lines)
				view.lnum = math.max(view.lnum, view.topline)
				view.lnum = math.min(view.lnum, new_bottom)
				if leftcol > 0 then
					local lines = vim.api.nvim_buf_get_lines(0, view.topline - 1, new_bottom, false)
					for i, line in ipairs(lines) do
						if #line >= leftcol then
							view.lnum = view.topline + i - 1
							view.col = leftcol
							view.coladd = 0
							break
						end
					end
				end
				vim.fn.winrestview(view)
			end)
		end,
	},
	layout = {
		reverse = true,
		layout = {
			box = "horizontal",
			width = 0.9,
			height = 0.85,
			border = "none",
			{
				box = "vertical",
				width = 0.55,
				border = "rounded",
				title = "  {title} ",
				title_pos = "center",
				{ win = "list", border = "none" },
				{ win = "input", height = 1, border = "top" },
			},
			{
				win = "preview",
				title = " {preview} ",
				title_pos = "center",
				width = 0.45,
				border = "rounded",
			},
		},
	},
	win = {
		input = {
			keys = {
				["<C-j>"] = { "list_down", mode = { "i", "n" } },
				["<C-k>"] = { "list_up", mode = { "i", "n" } },
				["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
				["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
				["<A-a>"] = { "select_all", mode = { "i", "n" } },
				["<C-s>"] = { "edit_vsplit", mode = { "i", "n" } },
				["<C-f>"] = { "preview_scroll_down_hpreserve", mode = { "i", "n" } },
				["<C-b>"] = { "preview_scroll_up_hpreserve", mode = { "i", "n" } },
				-- <A-f>/<A-b> override snacks default toggle_follow/<a-b>=gh_browse
				-- because normkey normalizes <A-f> and <a-f> to the same <M-f> key.
				["<A-f>"] = { "preview_scroll_right", mode = { "i", "n" }, desc = "Scroll preview right" },
				["<A-b>"] = { "preview_scroll_left", mode = { "i", "n" }, desc = "Scroll preview left" },
				["<A-h>"] = { "toggle_hidden", mode = { "i", "n" } },
				["<A-i>"] = { "toggle_ignored", mode = { "i", "n" } },
			},
		},
		-- Mirror all bindings on the list window so they work when focus
		-- moves out of the input (e.g. after pressing <Esc> or <C-j>).
		list = {
			keys = {
				["<C-j>"] = "list_down",
				["<C-k>"] = "list_up",
				["<Tab>"] = "select_and_next",
				["<S-Tab>"] = "select_and_prev",
				["<A-a>"] = "select_all",
				["<C-s>"] = "edit_vsplit",
				["<C-f>"] = "preview_scroll_down_hpreserve",
				["<C-b>"] = "preview_scroll_up_hpreserve",
				["<A-f>"] = { "preview_scroll_right", desc = "Scroll preview right" },
				["<A-b>"] = { "preview_scroll_left", desc = "Scroll preview left" },
				["<A-h>"] = "toggle_hidden",
				["<A-i>"] = "toggle_ignored",
			},
		},
		-- wrap=false required for horizontal scroll (list and preview).
		preview = {
			wo = { wrap = false },
		},
	},
	matcher = { frecency = true },
	-- Always start with hidden/ignored files OFF. Without this, the resume
	-- feature restores the last toggle state — so pressing A-h once would
	-- cause every subsequent picker session to show hidden files.
	hidden = false,
	ignored = false,
	toggles = {
		hidden = false, -- don't persist hidden-files toggle across sessions
		ignored = false, -- don't persist ignored-files toggle across sessions
	},
	-- Disable preview for ui_select: items (keymaps, actions, etc.) have no file.
	sources = {
		select = {
			preview = false,
		},

		-- ── marks: prominent mark label + file + line content ─────────────
		-- Built-in uses format="file" which just shows the path. We add a
		-- colour-coded [mark] badge (uppercase = global, lowercase = local),
		-- the shortened file path, and the actual line content for context.
		marks = {
			---@param item snacks.picker.Item
			---@return snacks.picker.Highlight[]
			format = function(item, picker)
				local ret = {} ---@type snacks.picker.Highlight[]
				local a = Snacks.picker.util.align
				local label = item.label or "?"

				-- ── mark badge ───────────────────────────────────────────
				local is_global = label:match("^[A-Z0-9]") ~= nil
				local mark_hl = is_global and "Title" or "SnacksPickerSpecial"
				ret[#ret + 1] = { "[", "SnacksPickerDelim" }
				ret[#ret + 1] = { label, mark_hl }
				ret[#ret + 1] = { "]", "SnacksPickerDelim" }
				ret[#ret + 1] = { "  " }

				-- ── position ─────────────────────────────────────────────
				local pos = item.pos
				local pos_str = pos and ("%d:%d"):format(pos[1], pos[2]) or "?:?"
				ret[#ret + 1] = { a(pos_str, 9), "SnacksPickerRow" }
				ret[#ret + 1] = { "  " }

				-- ── file path ────────────────────────────────────────────
				if item.file and item.file ~= "" then
					local short = vim.fn.fnamemodify(item.file, ":~:.")
					ret[#ret + 1] = { a(short, 35), "SnacksPickerFile" }
				else
					ret[#ret + 1] = { a("(no file)", 35), "NonText" }
				end
				ret[#ret + 1] = { "  " }

				-- ── line content ─────────────────────────────────────────
				if item.line and item.line ~= "" then
					local trimmed = item.line:gsub("^%s+", "")
					ret[#ret + 1] = { trimmed, "SnacksPickerComment" }
				end

				return ret
			end,
		},
	},
}
