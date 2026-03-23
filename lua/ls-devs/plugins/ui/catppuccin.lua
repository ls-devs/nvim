-- ── catppuccin ────────────────────────────────────────────────────────────
-- Purpose : Config-wide Catppuccin Mocha colorscheme with per-plugin integrations
-- Trigger : VeryLazy — loading eagerly (lazy=false) adds ~15ms to blocking startup
--           because catppuccin compiles its highlight cache on first load. The minor
--           color-flash tradeoff is preferable to blocking UIEnter.
--           Listed in core/lazy.lua install.colorscheme as fallback for first install.
-- Note    : transparent_background exposes terminal transparency; highlights are
--           compiled to ~/.cache/nvim/catppuccin for fast subsequent loads
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
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
			-- Allow terminal/compositor transparency to show through Neovim's background
			transparent_background = true,
			show_end_of_buffer = true,
			term_colors = true,
			no_italic = false,
			no_bold = false,
			no_underline = false,
			-- All empty tables: no extra bold/italic decorations on any syntax token
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
			---@param colors table
			---@return table
			custom_highlights = function(colors)
				return {
					-- Base NEOVIM
					TabLineSel = { fg = colors.lavender, bg = colors.surface0 },
					TabLine = { fg = colors.overlay0, bg = colors.surface0 },
					Pmenu = { bg = colors.none },
					PmenuSel = { bg = colors.overlay0, fg = colors.text, bold = true },
					Normal = { bg = colors.none },
					NormalFloat = { bg = colors.none },
					FloatTitle = { fg = colors.blue, bg = colors.none, style = { "bold" } },
					FloatBorder = { fg = colors.blue, bg = colors.none },
					FloatShadow = { bg = colors.surface0 },
					FloatShadowThrough = { bg = colors.surface0 },
					WinBar = { bg = colors.none },
					WinBarNC = { bg = colors.none },
					Folded = { bg = colors.none },
					StatusLine = { bg = colors.none },
					IncSearch = { fg = colors.base, bg = colors.peach, style = { "bold" } },
					Search = { fg = colors.base, bg = colors.peach, style = { "bold" } },
					CurSearch = { fg = colors.base, bg = colors.red, style = { "bold" } },
					WinSeparator = { fg = colors.blue, style = { "bold" } },
					CursorLineSign = { bg = colors.none },
					Cursor = { bg = "#ffffff" },
					-- GitSigns
					GitSignsCurrentLineBlame = { fg = colors.overlay1 },
					-- Fidget
					Fidget = { fg = colors.overlay1 },
					-- Bqf
					BqfPreviewThumb = { bg = colors.blue },
					-- NeoComposer
					DelaySymbol = { bg = colors.none },
					PlayingSymbol = { bg = colors.none },
					RecordingSymbol = { bg = colors.none },
					DelayText = { bg = colors.none },
					PlayingText = { bg = colors.none },
					RecordingText = { bg = colors.none },
					-- Blink.cmp - white icons on colored backgrounds
					BlinkCmpKindText = { fg = "#ffffff", bg = colors.green },
					BlinkCmpKindMethod = { fg = "#ffffff", bg = colors.blue },
					BlinkCmpKindFunction = { fg = "#ffffff", bg = colors.blue },
					BlinkCmpKindConstructor = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindField = { fg = "#ffffff", bg = colors.teal },
					BlinkCmpKindVariable = { fg = "#ffffff", bg = colors.mauve },
					BlinkCmpKindClass = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindInterface = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindModule = { fg = "#ffffff", bg = colors.blue },
					BlinkCmpKindProperty = { fg = "#ffffff", bg = colors.teal },
					BlinkCmpKindUnit = { fg = "#ffffff", bg = colors.green },
					BlinkCmpKindValue = { fg = "#ffffff", bg = colors.green },
					BlinkCmpKindEnum = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindKeyword = { fg = "#ffffff", bg = colors.red },
					BlinkCmpKindSnippet = { fg = "#ffffff", bg = colors.yellow },
					BlinkCmpKindColor = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindFile = { fg = "#ffffff", bg = colors.overlay2 },
					BlinkCmpKindReference = { fg = "#ffffff", bg = colors.overlay2 },
					BlinkCmpKindFolder = { fg = "#ffffff", bg = colors.blue },
					BlinkCmpKindEnumMember = { fg = "#ffffff", bg = colors.teal },
					BlinkCmpKindConstant = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindStruct = { fg = "#ffffff", bg = colors.peach },
					BlinkCmpKindEvent = { fg = "#ffffff", bg = colors.red },
					BlinkCmpKindOperator = { fg = "#ffffff", bg = colors.sky },
					BlinkCmpKindTypeParameter = { fg = "#ffffff", bg = colors.teal },
					BlinkCmpKindCopilot = { fg = "#ffffff", bg = colors.green },
					-- Neo-tree
					NeoTreeWinSeparator = { fg = colors.blue, bg = colors.none },
					SnacksPickerBorder = { fg = colors.blue },
					SnacksPickerTitle = { fg = colors.blue, style = { "bold" } },
					SnacksPickerMatch = { fg = colors.peach, style = { "bold" } },
					SnacksPickerListBorder = { fg = colors.blue },
					SnacksPickerPreviewBorder = { fg = colors.blue },
					SnacksPickerInputBorder = { fg = colors.blue },
					SnacksPickerInputTitle = { fg = colors.blue, style = { "bold" } },
					SnacksPickerPreviewTitle = { fg = colors.blue, style = { "bold" } },
					SnacksPickerListTitle = { fg = colors.blue, style = { "bold" } },
					SnacksPickerPrompt = { fg = colors.green, style = { "bold" } },
					-- File/dir split: path prefix (e.g. "lsp/") is always muted; filename
					-- fg is transparent (colors.none) so it inherits from line context:
					-- white on regular rows, peach on the cursor/selected row (via
					-- SnacksPickerListCursorLine fg = peach).
					SnacksPickerFile = { fg = colors.none },
					SnacksPickerDir = { fg = colors.overlay0 },
					SnacksPickerDirectory = { fg = colors.blue },
					-- Selected item highlight (winhighlight maps CursorLine →
					-- SnacksPickerListCursorLine when the list window is focused).
					SnacksPickerListCursorLine = { fg = colors.peach, bg = colors.surface0 },
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
					-- Noice
					NoiceVirtualText = { fg = colors.sky, style = { "bold" } },
					NoiceCmdlineIcon = { fg = colors.teal, style = { "bold" } },
					NoiceScrollbarThumb = { bg = colors.blue },
					-- Lazy
					LazyH1 = { bold = true, fg = colors.base, bg = colors.peach },
					LazyH2 = { fg = colors.blue, bold = true },
					LazySpecial = { fg = colors.flamingo, bold = true },
					-- Overseer
					OverseerTaskBorder = { fg = colors.blue },
					OverseerTask = { fg = colors.blue },
					OverseerField = { fg = colors.green },
					OverseerComponent = { fg = colors.yellow },
					OverseerOutput = { fg = colors.text },
					OverseerFAILURE = { fg = colors.red },
					OverseerSUCCESS = { fg = colors.green },
					OverseerRUNNING = { fg = colors.yellow },
					OverseerCANCELED = { fg = colors.overlay1 },
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
					CodeCompanionChatHeader = { fg = colors.base, bg = colors.peach, bold = true },
					-- Snacks dashboard (replaces Alpha highlights — same color mapping)
					SnacksDashboardHeader = { fg = colors.text },
					SnacksDashboardDesc = { fg = colors.blue },
					SnacksDashboardKey = { fg = colors.peach },
					SnacksDashboardIcon = { fg = colors.blue },
					SnacksDashboardFooter = { fg = colors.yellow },
					SnacksDashboardTitle = { fg = colors.blue, style = { "bold" } },
					SnacksDashboardSpecial = { fg = colors.peach },
				}
			end,
			-- Enable built-in catppuccin highlight patches for each supported plugin
			integrations = {
				snacks = true,
				blink_cmp = true,
				diffview = true,
				dap = true,
				fidget = true,
				window_picker = true,
				semantic_tokens = true,
				lsp_saga = true,
				mason = true,
				rainbow_delimiters = true,
				noice = true,
				neotree = true,
				gitsigns = true,
				treesitter = true,
				notify = false,
				flash = true,
				trouble = true,
				mini = {
					enabled = true,
				},
			},
			-- Compiled highlight definitions cached here for fast startup on subsequent loads
			compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
