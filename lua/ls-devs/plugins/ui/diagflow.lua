-- ── diagflow.nvim ─────────────────────────────────────────────────────────
-- Purpose : Inline diagnostic display anchored to the top-right of the current line
-- Trigger : LspAttach
-- Note    : virtual_text is disabled in nvim-lspconfig; diagflow takes full
--           ownership of diagnostic rendering
-- ─────────────────────────────────────────────────────────────────────────
return {
	"dgagn/diagflow.nvim",
	event = "LspAttach",
	opts = {
		-- Disable on the lazy.nvim UI to prevent rendering artifacts in that buffer
		enable = function()
			return vim.bo.filetype ~= "lazy"
		end,
		max_width = 60,
		max_height = 10,
		severity_colors = {
			error = "DiagnosticFloatingError",
			warn = "DiagnosticFloatingWarn",
			info = "DiagnosticFloatingInfo",
			hint = "DiagnosticFloatingHint",
		},
		format = function(diagnostic)
			return diagnostic.message
		end,
		gap_size = 1,
		-- Show only the diagnostic under the cursor, not every diagnostic on the line
		scope = "cursor",
		padding_top = 0,
		padding_right = 0,
		text_align = "right",
		-- Anchors the diagnostic box to the top-right corner of the current line
		placement = "top",
		inline_padding_left = 0,
		update_event = { "DiagnosticChanged", "BufReadPost" },
		-- Auto-hide diagnostics when entering insert mode
		toggle_event = { "InsertEnter" },
		show_sign = true,
		-- Re-render when new diagnostics arrive or the cursor moves to a new position
		render_event = { "DiagnosticChanged", "CursorMoved" },
		border_chars = {
			top_left = "┌",
			top_right = "┐",
			bottom_left = "└",
			bottom_right = "┘",
			horizontal = "─",
			vertical = "│",
		},
		-- border_chars defined above but borders are off; set true to draw the box outline
		show_borders = false,
	},
}
