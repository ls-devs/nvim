return {
	"simonmclean/triptych.nvim",
	cmd = "Triptych",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"nvim-tree/nvim-web-devicons", -- optional
	},
	opts = {
		mappings = {
			-- Everything below is buffer-local, meaning it will only apply to Triptych windows
			show_help = "g?",
			jump_to_cwd = ".", -- Pressing again will toggle back
			nav_left = "h",
			nav_right = { "l", "<CR>" },
			delete = "d",
			add = "a",
			copy = "c",
			rename = "r",
			cut = "x",
			paste = "p",
			quit = "q",
			toggle_hidden = "<leader>.",
		},
		extension_mappings = {},
		options = {
			dirs_first = true,
			show_hidden = false,
			line_numbers = {
				enabled = true,
				relative = true,
			},
			file_icons = {
				enabled = true,
				directory_icon = "",
				fallback_file_icon = "",
			},
			column_widths = { 0.25, 0.25, 0.5 }, -- Must add up to 1 after rounding to 2 decimal places
			highlights = { -- Highlight groups to use. See `:highlight` or `:h highlight`
				file_names = "NONE",
				directory_names = "NONE",
			},
			syntax_highlighting = { -- Applies to file previews
				enabled = true,
				debounce_ms = 100,
			},
		},
		git_signs = {
			enabled = true,
			signs = {
				add = "+",
				modify = "~",
				rename = "r",
				untracked = "?",
			},
		},
		diagnostic_signs = {
			enabled = true,
		},
	},
}
