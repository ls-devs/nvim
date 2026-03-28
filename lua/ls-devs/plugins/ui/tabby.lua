-- ── tabby.nvim ───────────────────────────────────────────────────────────────
-- Purpose : Custom tab line with active/inactive tab styling, smart tab name
--           resolution, and a window indicator list for the current tab.
-- Trigger : BufReadPost, BufWritePost, BufNewFile
-- Note    : <leader>tn=new tab, <leader>tr=rename, <leader>to=only,
--           <A-f>=next tab, <A-b>=prev tab, <leader>tmp/tmn=move tab.
-- ─────────────────────────────────────────────────────────────────────────────
---@param tab table
---@return string
local tabName = function(tab)
	local tabName = tab.name()
	local winid = vim.api.nvim_tabpage_get_win(tab.id)
	local bufid = vim.api.nvim_win_get_buf(winid)
	local file_type = vim.api.nvim_get_option_value("filetype", { buf = bufid })
	local bufpath = vim.api.nvim_buf_get_name(bufid)
	local tabTail = vim.fn.fnamemodify(bufpath, ":t")
	local tabParent = vim.fn.fnamemodify(bufpath, ":h:t")
	-- Include the immediate parent folder (e.g. "lsp/lspsaga.lua") unless the
	-- file is at the project root (parent is "." or "/") or has no real path.
	local tabDisplay = (tabParent ~= "" and tabParent ~= "." and tabParent ~= "/") and (tabParent .. "/" .. tabTail)
		or tabTail

	-- For tool windows (Overseer, neo-tree, snacks picker), use the filetype as the display name.
	if
		string.find(file_type, "Overseer")
		or string.find(file_type, "neo%-tree")
		or string.find(file_type, "snacks_picker")
	then
		tabName = file_type
	else
		-- Truncate long display names, preserving the extension (e.g. "very-long...ts").
		if string.len(tabDisplay) > 25 then
			local fileExt = string.match(tabTail, "[^.]+$") or ""
			tabName = string.sub(tabDisplay, 0, 22 - string.len(fileExt)) .. "..." .. fileExt
		else
			tabName = tabDisplay
		end
	end

	-- For floating terminals: use filetype as tab name, or fall back to buffer tail.
	if string.find(tabTail, "Floating") then
		if file_type == "" then
			local tail = vim.fn.expand("%:t")
			if string.find(tail, "npm") then
				tabName = string.gsub(tail, "%d+:", "")
			end
		else
			tabName = file_type
		end
	end

	-- Strip the `[N+]` modified-count suffix appended by Neovim to tab names.
	if tabName == "" then
		tabName = string.gsub(tab.name(), "%[%d+%+%]", "")
	end

	return string.gsub(tabName, "%[%d+%+%]", "")
end

---@type LazySpec
return {
	"nanozuki/tabby.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("tabby").setup()
		local colors = require("catppuccin.palettes.mocha")
		require("tabby.tabline").set(function(line)
			return {
				{
					line.sep(" ", {}, {}),
					{ "   ", hl = { fg = colors.green, bg = colors.none } },
				},
				line.tabs().foreach(function(tab)
					-- Active tab uses TabLineSel highlight; inactive tabs use TabLine.
					local hl = tab.is_current() and "TabLineSel" or "TabLine"
					return {
						line.sep("", { bg = colors.surface0 }, { bg = colors.none }),
						tab.is_current() and "" or "󰆣",
						tabName(tab),
						tab.close_btn(""),
						line.sep("", { bg = colors.surface0 }, { bg = colors.none }),
						hl = hl,
						margin = " ",
					}
				end),
				line.spacer(),
				-- Window indicators for the current tab: focused vs unfocused window icons.
				-- DapUI opens many panes — skip them so they don't flood the indicator list.
				line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
					local bufid = vim.api.nvim_win_get_buf(win.id)
					local ft = vim.api.nvim_get_option_value("filetype", { buf = bufid })
					if ft:match("^dapui") or ft == "dap-repl" then
						return {}
					end
					return {
						line.sep("", "TabLine", { bg = colors.none }),
						win.is_current() and "  " or "  ",
						line.sep("", "TabLine", { bg = colors.none }),
						hl = { bg = colors.surface0, fg = colors.lavender },
						margin = " ",
					}
				end),
				hl = { bg = colors.none },
			}
		end)
	end,
	keys = {
		{
			"<leader>tn",
			":$tabnew<CR>",
			desc = "New Tab",
			silent = true,
			noremap = true,
		},
		{
			"<leader>tr",
			":TabRename ",
			desc = "Rename Tab",
			noremap = true,
		},
		{
			"<leader>to",
			":tabonly<CR>",
			desc = "Tab Only",
			silent = true,
			noremap = true,
		},
		{
			"<A-f>",
			":tabn<CR>",
			desc = "Tab Next",
			silent = true,
			noremap = true,
		},
		{
			"<A-b>",
			":tabp<CR>",
			desc = "Tab Previous",
			silent = true,
			noremap = true,
		},
		{
			"<leader>tmp",
			":-tabmove<CR>",
			desc = "Tab Move Previous",
			silent = true,
			noremap = true,
		},
		{
			"<leader>tmn",
			":+tabmove<CR>",
			desc = "Tab Move Next",
			silent = true,
			noremap = true,
		},
	},
	dependencies = "echasnovski/mini.icons",
}
