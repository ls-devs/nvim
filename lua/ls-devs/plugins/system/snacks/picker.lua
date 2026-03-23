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

		-- ── autocmds: wider fields + desc/file priority ───────────────────
		-- Built-in truncates event@15, pattern@10, group@15 and shows "callback"
		-- for Lua autocmds. Here we widen all three, show a buffer indicator,
		-- and show desc first (before pattern/group) so it is immediately visible.
		autocmds = {
			---@param item snacks.picker.Item
			---@return snacks.picker.Highlight[]
			format = function(item, picker)
				local ret = {} ---@type snacks.picker.Highlight[]
				local au = item.item ---@type vim.api.keyset.get_autocmds.ret
				local a = Snacks.picker.util.align

				-- ── event ───────────────────────────────────────────────
				ret[#ret + 1] = { a(au.event or "?", 20), "SnacksPickerAuEvent" }
				ret[#ret + 1] = { "  " }

				-- ── buffer-local indicator (mirrors keymaps style) ───────
				if au.buffer and au.buffer > 0 then
					ret[#ret + 1] = { "b ", "SnacksPickerBufNr" }
				else
					ret[#ret + 1] = { "  " }
				end

				-- ── description / command / file:line / ‹callback› ──────
				if au.desc and au.desc ~= "" then
					ret[#ret + 1] = { a(au.desc, 40), "Normal" }
				elseif au.command and au.command ~= "" then
					Snacks.picker.highlight.format(item, a(au.command, 40), ret, { lang = "vim" })
				elseif item.file then
					local short = vim.fn.fnamemodify(item.file, ":~:.")
					local pos = item.pos and (":%d"):format(item.pos[1]) or ""
					ret[#ret + 1] = { a(short .. pos, 40), "SnacksPickerFile" }
				else
					ret[#ret + 1] = { a("‹callback›", 40), "NonText" }
				end
				ret[#ret + 1] = { "  " }

				-- ── pattern ─────────────────────────────────────────────
				local pat = au.pattern or "*"
				ret[#ret + 1] = { a(pat, 18), "SnacksPickerAuPattern" }
				ret[#ret + 1] = { "  " }

				-- ── group ───────────────────────────────────────────────
				local grp = tostring(au.group_name or "")
				ret[#ret + 1] = { a(grp, 22), "SnacksPickerAuGroup" }

				return ret
			end,
		},

		-- ── commands: name + nargs badge + description ────────────────────
		-- Built-in only shows `name [desc]`. We add an aligned name, a nargs
		-- badge so you know the arity at a glance, and dim the definition when
		-- no human-readable description is available.
		commands = {
			---@param item snacks.picker.Item
			---@return snacks.picker.Highlight[]
			format = function(item, picker)
				local ret = {} ---@type snacks.picker.Highlight[]
				local a = Snacks.picker.util.align
				local cmd = item.command or {} ---@type table

				-- ── command name ─────────────────────────────────────────
				local is_builtin = item.cmd and item.cmd:find("^[a-z]") ~= nil
				local name_hl = is_builtin and "SnacksPickerCmdBuiltin" or "SnacksPickerCmd"
				ret[#ret + 1] = { a(item.cmd or item.text or "?", 28), name_hl }
				ret[#ret + 1] = { "  " }

				-- ── nargs badge ──────────────────────────────────────────
				local nargs_map =
					{ ["0"] = "no-args", ["1"] = "1-arg ", ["*"] = "n-args", ["?"] = "opt   ", ["+"] = "1+args" }
				local nargs_hl_map = {
					["0"] = "NonText",
					["1"] = "SnacksPickerSpecial",
					["*"] = "Function",
					["?"] = "DiagnosticHint",
					["+"] = "DiagnosticWarn",
				}
				local n = cmd.nargs or "0"
				ret[#ret + 1] = { a(nargs_map[n] or n, 6), nargs_hl_map[n] or "NonText" }
				ret[#ret + 1] = { "  " }

				-- ── description or definition (dim) ──────────────────────
				local desc = item.desc or (cmd.desc ~= "" and cmd.desc or nil)
				if desc then
					ret[#ret + 1] = { desc, "SnacksPickerDesc" }
				elseif cmd.definition and cmd.definition ~= "" and cmd.definition ~= "completion" then
					ret[#ret + 1] = { cmd.definition, "NonText" }
				end

				return ret
			end,
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

		-- ── keymaps: custom readable layout ──────────────────────────────
		-- The built-in formatter truncates desc@20 and lhs@15.
		-- We replace it: [mode] key(22)  description(50)  source/rhs(dim).
		-- A wider list pane (65%) gives room for long descriptions.
		keymaps = {
			layout = {
				reverse = true,
				layout = {
					box = "horizontal",
					width = 0.95,
					height = 0.85,
					border = "none",
					{
						box = "vertical",
						width = 0.65,
						border = "rounded",
						title = "  Keymaps ",
						title_pos = "center",
						{ win = "list", border = "none" },
						{ win = "input", height = 1, border = "top" },
					},
					{
						win = "preview",
						title = " {preview} ",
						title_pos = "center",
						width = 0.35,
						border = "rounded",
					},
				},
			},

			---@param item snacks.picker.Item
			---@param picker snacks.Picker
			---@return snacks.picker.Highlight[]
			format = function(item, picker)
				local ret = {} ---@type snacks.picker.Highlight[]
				local k = item.item ---@type vim.api.keyset.get_keymap
				local a = Snacks.picker.util.align

				-- ── mode badge [n] / [v] / [i] ─────────────────────────
				local mode_hl = ({
					n = "SnacksPickerKeymapMode",
					v = "Title",
					x = "Title",
					i = "Function",
					c = "Keyword",
					t = "SnacksPickerSpecial",
					o = "DiagnosticWarn",
					s = "DiagnosticInfo",
				})[k.mode] or "SnacksPickerKeymapMode"
				ret[#ret + 1] = { "[", "SnacksPickerDelim" }
				ret[#ret + 1] = { a(k.mode or "?", 1), mode_hl }
				ret[#ret + 1] = { "] ", "SnacksPickerDelim" }

				-- ── buffer-local indicator ──────────────────────────────
				if k.buffer and k.buffer > 0 then
					ret[#ret + 1] = { "b ", "SnacksPickerBufNr" }
				else
					ret[#ret + 1] = { "  " }
				end

				-- ── key binding ─────────────────────────────────────────
				local lhs = Snacks.util.normkey(k.lhs)
				ret[#ret + 1] = { a(lhs, 22), "SnacksPickerKeymapLhs" }
				ret[#ret + 1] = { "  " }

				-- ── description (primary, widened) ──────────────────────
				local desc = (k.desc and k.desc ~= "") and k.desc or ""
				local desc_hl = desc ~= "" and "Normal" or "NonText"
				ret[#ret + 1] = { a(desc ~= "" and desc or "(no description)", 50), desc_hl }
				ret[#ret + 1] = { "  " }

				-- ── source: file path or stripped RHS (dim) ─────────────
				if item.file then
					local short = vim.fn.fnamemodify(item.file, ":~:.")
					ret[#ret + 1] = { short, "SnacksPickerFile" }
				elseif k.rhs and k.rhs ~= "" then
					-- Strip <Cmd>...<CR> wrapper so it's readable
					local rhs = k.rhs:gsub("^%<[Cc][Mm][Dd]%>(.-)%<[Cc][Rr]%>$", "%1")
					ret[#ret + 1] = { rhs, "NonText" }
				end

				return ret
			end,
		},
	},
}
