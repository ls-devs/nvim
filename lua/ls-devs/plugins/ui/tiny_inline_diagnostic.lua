-- ── tiny-inline-diagnostic.nvim ──────────────────────────────────────────
-- Purpose : Inline diagnostic display with boxed virtual text, replaces diagflow.nvim
-- Trigger : LspAttach
-- Note    : virtual_text is disabled globally; this plugin owns diagnostic rendering.
--           Diagnostics are hidden in insert mode (mirrors diagflow toggle_event).
--           Off-cursor lines show only a severity dot + count; full message
--           appears when the cursor moves onto the line (display_count = true).
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000,
	-- Suppress in the lazy.nvim UI buffer without autocmd overhead
	disabled_ft = { "lazy" },
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "modern",
			-- Replace the default rounded nerd-font caps (U+E0B6 / U+E0B4) with
			-- empty strings: the background highlight alone defines the container,
			-- avoiding both rounded caps and the half-block gap of block chars.
			signs = {
				left = "",
				right = "",
				vertical = " │",
				vertical_end = " └",
			},
			-- Keep cursorline transparent so the cursor-line bg shows through
			transparent_cursorline = true,
			hi = {
				error = "DiagnosticError",
				warn = "DiagnosticWarn",
				info = "DiagnosticInfo",
				hint = "DiagnosticHint",
				arrow = "NonText",
				-- CursorLine maps to catppuccin surface0 (#313244)
				background = "CursorLine",
				-- Blend against Normal so the box reads as a tinted diagnostic colour
				mixing_color = "Normal",
			},
			options = {
				-- Stay hidden while typing (mirrors diagflow toggle_event)
				enable_on_insert = false,
				throttle = 20,
				softwrap = 30, -- under-placement threshold: goes below line if visual_width > win_width - softwrap
				-- Off-cursor lines: show dot + count only; cursor line: full message
				add_messages = {
					messages = true,
					display_count = true,
					use_max_severity = true,
					show_multiple_glyphs = false,
				},
				-- multilines must be enabled for display_count to work
				multilines = {
					enabled = true,
					always_show = false,
				},
				show_source = { enabled = false },
				show_code = false,
				break_line = {
					enabled = false,
					after = 60,
				},
				overflow = { mode = "wrap" },
				virt_texts = { priority = 2048 },
			},
		})

		-- Disable Neovim's built-in virtual_text; this plugin takes full ownership
		vim.diagnostic.config({ virtual_text = false })
	end,
}
