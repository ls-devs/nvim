require("barbecue").setup({
  theme = "catppuccin",
	show_navic = false,
  show_modified = true,
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
