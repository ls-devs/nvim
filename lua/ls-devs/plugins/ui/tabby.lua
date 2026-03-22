-- ── tabby.nvim ───────────────────────────────────────────────────────────────
-- Purpose : Custom tab line with active/inactive tab styling, smart tab name
--           resolution, and a window indicator list for the current tab.
-- Trigger : BufReadPost, BufWritePost, BufNewFile
-- Note    : <leader>tn=new tab, <leader>tr=rename, <leader>to=only,
--           <A-f>=next tab, <A-b>=prev tab, <leader>tmp/tmn=move tab.
-- ─────────────────────────────────────────────────────────────────────────────
local tabName = function(tab)
	local tabName = tab.name()
	local winid = vim.api.nvim_tabpage_get_win(tab.id)
	local bufid = vim.api.nvim_win_get_buf(winid)
	local file_type = vim.api.nvim_get_option_value("filetype", { buf = bufid })
	local tabTail = vim.fn.fnamemodify(tab.name(), "%:t")

	-- For tool windows (Overseer, neo-tree, snacks picker), use the filetype as the display name.
	if
		string.find(file_type, "Overseer")
		or string.find(file_type, "neo%-tree")
		or string.find(file_type, "snacks_picker")
	then
		tabName = file_type
	else
		-- Truncate long filenames, preserving the extension (e.g. "very-long-name...ts").
		if string.len(tabTail) > 25 then
			local fileExt = string.match(tabTail, "[^.]+$")
			tabName = string.sub(tabTail, 0, 22 - string.len(fileExt)) .. "..." .. fileExt
		end
	end

	-- For floating terminals: strip any legacy toggleterm numeric suffix from buffer name.
	-- (toggleterm replaced by snacks.terminal; this branch is dead but harmless)
	if string.find(tabTail, "Floating") then
		if vim.bo.filetype == "" then
			local tail = vim.fn.expand("%:t")
			if string.find(tail, "toggleterm") then
				local pID = string.gsub(tail, "%d+:", "")
				tabName = string.gsub(pID, ";#toggleterm#%d+", "")
			end
			if string.find(tail, "npm") then
				tabName = string.gsub(tail, "%d+:", "")
			end
		else
			tabName = vim.bo.filetype
		end
	end

	-- Strip the `[N+]` modified-count suffix appended by Neovim to tab names.
	if tabName == "" then
		tabName = string.gsub(tab.name(), "%[%d+%+%]", "")
	end

	return string.gsub(tabName, "%[%d+%+%]", "")
end

return {
	"nanozuki/tabby.nvim",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
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
				line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
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
	dependencies = "nvim-tree/nvim-web-devicons",
}
