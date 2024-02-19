return {
	"catppuccin/nvim",
	name = "catppuccin",
	event = "VeryLazy",
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = true,
			no_italic = true,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			custom_highlights = function(colors)
				return {
					TabLineSel = { fg = colors.lavender, bg = colors.surface0 },
					TabLine = { fg = colors.overlay0, bg = colors.surface0 },
					CmpBorder = { fg = colors.surface2 },
					Pmenu = { bg = colors.none },
					Normal = { bg = colors.none },
					DelaySymbol = { bg = colors.none },
					PlayingSymbol = { bg = colors.none },
					RecordingSymbol = { bg = colors.none },
					DelayText = { bg = colors.none },
					PlayingText = { bg = colors.none },
					RecordingText = { bg = colors.none },
					LeapBackdrop = { fg = colors.none },
					LeapLabelPrimary = { bg = colors.red, fg = colors.base, style = { "bold" and "underline" } },
					LeapLabelSecondary = { bg = colors.sapphire, fg = colors.base, style = { "bold" and "underline" } },
					WinBar = { bg = colors.none },
					WinBarNC = { bg = colors.none },
					GitSignsCurrentLineBlame = { fg = colors.overlay1 },
					Folded = { bg = colors.none },
					CmpItemKindVariable = { fg = colors.mauve },
					CmpItemKindSnippet = { fg = colors.blue },
					StatusLine = { bg = colors.none },
					Fidget = { fg = colors.overlay1 },
					TelescopeNormal = { fg = colors.none },
					TelescopeSelection = { fg = colors.peach },
					IncSearch = { fg = colors.base, bg = colors.peach, style = { "bold" } },
					Search = { fg = colors.base, bg = colors.peach, style = { "bold" } },
					CurSearch = { fg = colors.base, bg = colors.red, style = { "bold" } },
					-- Lazy
					LazyH1 = { bold = true, fg = colors.base, bg = colors.peach },
					LazyH2 = { fg = colors.blue, bold = true },
					LazySpecial = { fg = colors.flamingo, bold = true },
					-- Mason
					MasonHeader = { fg = colors.base, bg = colors.peach },
					MasonHeaderSecondary = { fg = colors.base, bg = colors.pink },
					MasonHighlight = { fg = colors.pink },
					MasonHighlightBlock = { bg = colors.pink, fg = colors.base },
					MasonHighlightBlockBold = { bg = colors.pink, fg = colors.base, bold = true },
					MasonHighlightSecondary = { fg = colors.red },
					MasonHighlightBlockSecondary = { bg = colors.red, fg = colors.base },
					MasonHighlightBlockBoldSecondary = { bg = colors.red, fg = colors.base, bold = true },
					MasonLink = { fg = colors.rosewater },
					MasonMuted = { fg = colors.overlay1 },
					MasonMutedBlock = { bg = colors.surface0, fg = colors.text },
					MasonMutedBlockBold = { bg = colors.surface0, fg = colors.overlay1, bold = true },
					MasonError = { fg = colors.red },
					MasonHeading = { bold = true },
					-- Alpha
					AlphaHeader = { fg = colors.text },
					AlphaButtons = { fg = colors.blue },
					AlphaShortcut = { fg = colors.peach },
				}
			end,
			integrations = {
				cmp = true,
				dap = true,
				dashboard = true,
				fidget = true,
				window_picker = true,
				semantic_tokens = true,
				lsp_saga = true,
				mason = true,
				rainbow_delimiters = true,
				overseer = true,
				noice = true,
				neotree = true,
				neotest = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = true,
				leap = true,
				dap_ui = true,
				alpha = true,
				telescope = {
					enabled = true,
				},
				mini = {
					enabled = true,
				},
			},
			compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
