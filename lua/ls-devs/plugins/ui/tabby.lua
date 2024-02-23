local tabName = function(tab)
	local tabName = tab.name()
	local winid = vim.api.nvim_tabpage_get_win(tab.id)
	local bufid = vim.api.nvim_win_get_buf(winid)
	local file_type = vim.api.nvim_get_option_value("filetype", { buf = bufid })
	local tabTail = vim.fn.fnamemodify(tab.name(), "%:t")

	if string.find(file_type, "Overseer") or string.find(file_type, "neo") then
		tabName = file_type
	else
		if string.len(tabTail) > 25 then
			local fileExt = string.match(tabTail, "[^.]+$")
			tabName = string.sub(tabTail, 0, 22 - string.len(fileExt)) .. "..." .. fileExt
		end
	end

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
				line.tabs().foreach(function(tab)
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
