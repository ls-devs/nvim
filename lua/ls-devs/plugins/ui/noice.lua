return {
	"folke/noice.nvim",
	event = "VimEnter",
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
					enabled = false,
					trigger = false,
					luasnip = false,
					throttle = 50,
				},
				view = nil,
				opts = {},
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
				["|(%S-)|"] = vim.cmd.help,
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
			enabled = true,
			backend = "nui",
			kind_icons = {},
		},
		redirect = {
			view = "popup",
			filter = { event = "msg_show" },
		},
		health = {
			checker = true,
		},
		presets = {
			bottom_search = false,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = true,
			lsp_doc_border = "rounded",
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
		{ "MunifTanjim/nui.nvim", lazy = true },
		{
			"rcarriga/nvim-notify",
			lazy = true,
			opts = {
				background_colour = "#000000",
				top_down = false,
				timeout = 1000,
				render = "wrapped-compact",
			},
		},
	},
}
