return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true, -- disables setting the background color.
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = true, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
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
					TabLineSel = { fg = colors.green, bg = colors.surface0 },
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
					MiniIndentscopeSymbol = { fg = colors.peach },
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
					-- Lazy
					LazyButtonActive = { bold = true, fg = colors.base, bg = colors.pink },
					LazyButton = { fg = colors.text, bold = true },
					LazyH1 = { bold = true, fg = colors.base, bg = colors.peach },
					LazyH2 = { fg = colors.text, bold = true },
					LazySpecial = { fg = colors.lavender, bold = true },
					LazyProgressTodo = { fg = colors.none, bg = colors.none, bold = true },
					LazyProgressDone = { fg = colors.pink, bg = colors.none, bold = true },
					LazyReasonEvent = { fg = colors.peach, bold = true },
				}
			end,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = true,
				leap = true,
				dap_ui = true,
				aerial = true,
				alpha = true,
				telescope = {
					enabled = true,
				},
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		})
	end,
	init = function()
		vim.cmd.colorscheme("catppuccin")
	end,
}
