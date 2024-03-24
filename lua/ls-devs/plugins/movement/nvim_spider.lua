return {
	"chrisgrieser/nvim-spider",
	opts = {
		skipInsignificantPunctuation = true,
		subwordMovement = true,
		customPatterns = {},
	},
	init = function()
		vim.keymap.set("n", "cw", "c<cmd>lua require('spider').motion('e')<CR>")
	end,
	keys = {
		{
			"w",
			function()
				require("spider").motion("w")
			end,
			mode = { "n", "o", "x" },
		},
		{
			"e",
			function()
				require("spider").motion("e")
			end,
			mode = { "n", "o", "x" },
		},
		{
			"b",
			function()
				require("spider").motion("b")
			end,
			mode = { "n", "o", "x" },
		},
	},
}
