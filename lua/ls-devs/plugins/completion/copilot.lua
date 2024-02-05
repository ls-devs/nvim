return {
	"zbirenbaum/copilot-cmp",
	cmd = "Copilot",
	opts = {
		event = { "InsertEnter", "LspAttach" },
		fix_pairs = true,
	},
	keys = {
		{
			"<leader>cp",
			"<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>",
			desc = "Toggle Copilot",
			noremap = true,
			silent = true,
		},
	},
	dependencies = {
		"zbirenbaum/copilot.lua",
		opts = {
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
				layout = {
					position = "bottom",
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = false,
				debounce = 75,
				keymap = {
					accept = "<C-a>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node",
			server_opts_overrides = {},
		},
	},
}
