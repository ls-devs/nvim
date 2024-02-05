return {
	"ecthelionvi/NeoComposer.nvim",
	event = "BufReadPost",
	opts = {
		notify = false,
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
		local colors = require("tokyonight.colors").setup()
		require("NeoComposer").setup(vim.tbl_deep_extend("force", opts, {
			colors = {
				bg = colors.none,
				fg = colors.orange,
				red = colors.red,
				blue = colors.blue,
				green = colors.green,
				text_bg = colors.none,
			},
		}))
		require("telescope").load_extension("macros")
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
	dependencies = { "kkharji/sqlite.lua" },
}
