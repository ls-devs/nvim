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
	dependencies = {
		"theHamsta/nvim_rocks",
		lazy = true,
		build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
		config = function()
			require("nvim_rocks").ensure_installed("luautf8")
		end,
	},
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
