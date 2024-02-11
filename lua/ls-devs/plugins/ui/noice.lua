return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			progress = {
				enabled = false,
			},
			hover = {
				enabled = true,
				silent = true,
			},
			signature = {
				enabled = true,
				auto_open = {
					enabled = true,
					trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
					luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
					throttle = 50, -- Debounce lsp signature help request by 50ms
				},
				view = nil, -- when nil, use defaults from documentation
				opts = {}, -- merged with defaults from documentation
			},
			documentation = {
				view = "hover",
				opts = {
					lang = "markdown",
					replace = true,
					render = "plain",
					format = { "{message}" },
					win_options = { concealcursor = "n", conceallevel = 3 },
				},
			},
		},
		markdown = {
			hover = {
				["|(%S-)|"] = vim.cmd.help, -- vim help links
			},
			highlights = {
				["|%S-|"] = "@text.reference",
				["@%S+"] = "@parameter",
				["^%s*(Parameters:)"] = "@text.title",
				["^%s*(Return:)"] = "@text.title",
				["^%s*(See also:)"] = "@text.title",
				["{%S-}"] = "@parameter",
			},
		},
		popupmenu = {
			enabled = true, -- enables the Noice popupmenu UI
			backend = "nui", -- backend to use to show regular cmdline completions
			kind_icons = {}, -- set to `false` to disable icons
		},
		redirect = {
			view = "popup",
			filter = { event = "msg_show" },
		},
		health = {
			checker = true, -- Disable if you don't want health checks to run
		},
		presets = {
			bottom_search = false, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = true, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = "rounded", -- add a border to hover docs and signature help
		},
		notify = {
			enabled = true,
			view = "notify",
			replace = true,
			merge = true,
		},
		messages = {
			enabled = true,
		},
		views = {
			cmdline_popup = {
				position = {
					row = 5,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
			},
			popupmenu = {
				relative = "editor",
				position = {
					row = 8,
					col = "50%",
				},
				size = {
					width = 60,
					height = 10,
				},
				border = {
					style = "rounded",
					padding = { 0, 1 },
				},
				win_options = {
					winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
				},
			},
		},
		smart_move = {
			enabled = true, -- you can disable this behaviour here
			excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
		},
	},
	config = function(_, opts)
		require("noice").setup(vim.tbl_deep_extend("force", opts, {
			markdown = {
				hover = {
					["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
				},
			},
		}))
	end,
	dependencies = {
		{ "MunifTanjim/nui.nvim", event = "VeryLazy" },
		{
			"ls-devs/nvim-notify",
			event = "BufReadPost",
			opts = {
				background_colour = "#000000",
				top_down = false,
				timeout = 1000,
			},
		},
	},
}
