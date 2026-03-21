-- ── NeoComposer.nvim ──────────────────────────────────────────────────────
-- Purpose : Enhanced macro composer with floating UI, history, and sqlite persistence
-- Trigger : keys — @, Q, <A-q>, <leader>q, <leader>yq, <leader>sq, <leader>qn/qp
-- Note    : `q` is remapped to <Nop> in init so it doesn't start a raw recording;
--           Q toggles recording, @ plays, <A-q>/<leader>q open the macro menu
-- ─────────────────────────────────────────────────────────────────────────
return {
	"ecthelionvi/NeoComposer.nvim",
	opts = {
		notify = true,
		-- Milliseconds to wait before treating keystrokes as macro input
		delay_timer = 150,
		-- Always queue the most recently recorded macro for playback
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
		-- Merge catppuccin mocha palette into NeoComposer's color table at setup time
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
		-- Style the floating preview window to match the theme
		vim.cmd("hi Preview guibg=" .. colors.surface0 .. " guifg=" .. colors.flamingo)
	end,
	init = function()
		-- Disable the built-in `q` register-record key so NeoComposer owns recording via Q
		vim.keymap.set("n", "q", "<Nop>", { noremap = true, silent = true })
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
				require("NeoComposer.ui").toggle_macro_menu()
			end,
			desc = "NeoComposer Toggle Macro Menu",
			silent = true,
			noremap = true,
		},
		{
			"Q",
			function()
				require("NeoComposer.macro").toggle_record()
			end,
			desc = "NeoComposer Toggle Record",
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
