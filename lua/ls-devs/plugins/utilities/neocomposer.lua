return {
	"ecthelionvi/NeoComposer.nvim",
	opts = {
		notify = true,
		delay_timer = 150,
		queue_most_recent = true,
		window = {
			border = "rounded",
			winhl = {
				Normal = "Normal",
			},
		},
		keymaps = {
			play_macro = "@",
			yank_macro = "yq",
			stop_macro = "cq",
			toggle_record = "Q",
			cycle_next = "<leader>qn",
			cycle_prev = "<leader>qp",
			toggle_macro_menu = "<A-q>",
		},
	},
	config = function(_, opts)
		local colors = require("catppuccin.palettes.mocha")
		require("NeoComposer").setup(vim.tbl_deep_extend("force", opts, {
			colors = {
				bg = colors.base,
				fg = colors.peach,
				red = colors.red,
				blue = colors.blue,
				green = colors.green,
			},
		}))
		require("telescope").load_extension("macros")
		vim.cmd("hi Preview guibg=" .. colors.surface0 .. " guifg=" .. colors.flamingo)
	end,
	init = function()
		vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })
	end,
	keys = {
		{
			"@",
			function()
				require("NeoComposer.macro").play_macro()
			end,
			desc = "NeoComposer Play Macro",
			silent = true,
			noremap = true,
		},
		{
			"<leader>yq",
			function()
				require("NeoComposer.macro").yank_macro()
			end,
			desc = "NeoComposer Yank Macro",
			silent = true,
			noremap = true,
		},
		{
			"<leader>sq",
			function()
				require("NeoComposer.macro").stop_macro()
			end,
			desc = "NeoComposer Stop Macro",
			silent = true,
			noremap = true,
		},
		{
			"<A-q>",
			function()
				require("NeoComposer.macro").toggle_record()
			end,
			desc = "NeoComposer Record Macro",
			silent = true,
			noremap = true,
		},
		{
			"<leader>qn",
			function()
				require("NeoComposer.ui").cycle_next()
			end,
			desc = "NeoComposer Cycle Next",
			silent = true,
			noremap = true,
		},
		{
			"<leader>qp",
			function()
				require("NeoComposer.ui").cycle_prev()
			end,
			desc = "NeoComposer Cycle Prev",
			silent = true,
			noremap = true,
		},
		{
			"<leader>q",
			function()
				require("NeoComposer.ui").toggle_macro_menu()
			end,
			desc = "NeoComposer Toggle Menu",
			silent = true,
			noremap = true,
		},
	},
	dependencies = { { "kkharji/sqlite.lua", lazy = true } },
}
