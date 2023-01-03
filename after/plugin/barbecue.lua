require("barbecue").setup({
	show_navic = false,
  custom_section = function()
    return vim.bo.filetype
  end,
  show_modified = true,
  theme = "catppuccin",
	create_autocmd = false, -- prevent barbecue from updating itself automatically
	attach_navic = false,
})

vim.api.nvim_create_autocmd({
	"WinScrolled",
	"BufWinEnter",
	"CursorHold",
	"InsertLeave",

	-- include these if you have set `show_modified` to `true`
	"BufWritePost",
	"TextChanged",
	"TextChangedI",
}, {
	group = vim.api.nvim_create_augroup("barbecue#create_autocmd", {}),
	callback = function()
		require("barbecue.ui").update()
	end,
})
