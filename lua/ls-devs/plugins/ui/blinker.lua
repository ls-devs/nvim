return {
	"Grazfather/blinker.nvim",
	opts = {
		count = 2,
		duration = 100,
		color = "#cdd6f4",
		highlight = "BlinkingLine",
	},
	keys = {
		{
			"<leader><leader>",
			"<cmd>lua require('blinker').blink_cursorline()<CR>",
			desc = "Blink Cursor",
			silent = true,
			noremap = true,
		},
	},
}
