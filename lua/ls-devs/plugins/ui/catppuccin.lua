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
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = {},
				conditionals = {},
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
				miscs = {},
			},
			color_overrides = {},
			custom_highlights = function(colors)
				return {
					-- Base NEOVIM
					TabLineSel = { fg = colors.lavender, bg = colors.surface0 },
					TabLine = { fg = colors.overlay0, bg = colors.surface0 },
					Pmenu = { bg = colors.none },
					Normal = { bg = colors.none },
					NormalFloat = { bg = colors.none },
					FloatBorder = { bg = colors.none },
					FloatShadow = { bg = colors.none },
					FloatShadowThrough = { bg = colors.none },
					WinBar = { bg = colors.none },
					WinBarNC = { bg = colors.none },
					Folded = { bg = colors.none },
					StatusLine = { bg = colors.none },
					IncSearch = { fg = colors.base, bg = colors.peach, style = { "bold" } },
					Search = { fg = colors.base, bg = colors.peach, style = { "bold" } },
					CurSearch = { fg = colors.base, bg = colors.red, style = { "bold" } },
					WinSeparator = { fg = colors.overlay0, style = { "bold" } },
					CursorLineSign = { bg = colors.none },
					Cursor = { bg = "#ffffff" },
					-- GitSigns
					GitSignsCurrentLineBlame = { fg = colors.overlay1 },
					-- Fidget
					Fidget = { fg = colors.overlay1 },
					-- Bqf
					BqfPreviewThumb = { bg = colors.blue },
					-- DiffView
					-- DiffDelete = { fg = colors.overlay0, bg = colors.none, style = {} },
					-- NeoComposer
					DelaySymbol = { bg = colors.none },
					PlayingSymbol = { bg = colors.none },
					RecordingSymbol = { bg = colors.none },
					DelayText = { bg = colors.none },
					PlayingText = { bg = colors.none },
					RecordingText = { bg = colors.none },
					-- Leap
					LeapBackdrop = { fg = colors.none },
					LeapLabelPrimary = { bg = colors.red, fg = colors.base, style = { "bold" and "underline" } },
					LeapLabelSecondary = { bg = colors.green, fg = colors.base, style = { "bold" and "underline" } },
					-- CMP
					CmpItemKindVariable = { fg = colors.mauve },
					CmpBorder = { fg = colors.surface2 },
					CmpItemKindSnippet = { fg = colors.blue },
					-- Telescope
					TelescopeNormal = { fg = colors.none },
					TelescopeSelection = { fg = colors.peach },
					-- Notify
					NotificationInfo = { bg = colors.none, fg = colors.text },
					NotificationError = { bg = colors.none, fg = colors.red },
					NotificationWarning = { bg = colors.none, fg = colors.yellow },
					NotifyINFOTitle = { style = { "bold" } },
					NotifyDEBUGTitle = { style = { "bold" } },
					NotifyWARNTitle = { style = { "bold" } },
					NotifyTRACETitle = { style = { "bold" } },
					NotifyERRORTitle = { style = { "bold" } },
					-- LspSaga
					SagaBeacon = { bg = colors.red },
					-- Diagnostics
					DiagnosticInfo = { style = { "bold" } },
					DiagnosticWarn = { style = { "bold" } },
					DiagnosticError = { style = { "bold" } },
					DiagnosticHint = { style = { "bold" } },
					DiagnosticVirtualTextInfo = { style = { "bold" } },
					DiagnosticVirtualTextWarn = { style = { "bold" } },
					DiagnosticVirtualTextError = { style = { "bold" } },
					DiagnosticVirtualTextHint = { style = { "bold" } },
					LspDiagnosticsVirtualTextInformation = { style = { "bold" } },
					LspDiagnosticsVirtualTextWarning = { style = { "bold" } },
					LspDiagnosticsVirtualTextError = { style = { "bold" } },
					LspDiagnosticsVirtualTextHint = { style = { "bold" } },
					-- Noice
					NoiceVirtualText = { fg = colors.sky, style = { "bold" } },
					NoiceCmdlineIcon = { fg = colors.teal, style = { "bold" } },
					NoiceScrollbarThumb = { bg = colors.blue },
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
				diffview = true,
				dap = true,
				harpoon = true,
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
				leap = false,
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
