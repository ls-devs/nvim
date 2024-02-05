local ftMap = {
	vim = "indent",
	python = { "indent" },
	git = "",
}

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󱞤 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

return {
	"kevinhwang91/nvim-ufo",
	event = "BufRead",
	config = function()
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return ftMap[filetype] or { "treesitter", "indent" }
			end,
			fold_virt_text_handler = handler,
			preview = {
				win_config = {
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},
		})
	end,
	dependencies = {
		{ "kevinhwang91/promise-async" },
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				require("statuscol").setup({

					foldfunc = "builtin",
					setopt = true,
					relculright = true,
					segments = {
						{ text = { "%s" }, click = "v:lua.ScSa" },
						{ text = { require("statuscol.builtin").lnumfunc, " " }, click = "v:lua.ScLa" },
						{ text = { require("statuscol.builtin").foldfunc, "  " }, click = "v:lua.ScFa" },
					},
				})
			end,
		},
	},
}
