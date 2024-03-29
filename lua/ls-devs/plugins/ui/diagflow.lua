return {
	"dgagn/diagflow.nvim",
	event = "LspAttach",
	opts = {
		enable = function()
			return vim.bo.filetype ~= "lazy"
		end,
		max_width = 60,
		max_height = 10,
		severity_colors = {
			error = "DiagnosticFloatingError",
			warning = "DiagnosticFloatingWarn",
			info = "DiagnosticFloatingInfo",
			hint = "DiagnosticFloatingHint",
		},
		format = function(diagnostic)
			return diagnostic.message
		end,
		gap_size = 1,
		scope = "cursor",
		padding_top = 0,
		padding_right = 0,
		text_align = "right",
		placement = "top",
		inline_padding_left = 0,
		update_event = { "DiagnosticChanged", "BufReadPost" },
		toggle_event = { "InsertEnter" },
		show_sign = true,
		render_event = { "DiagnosticChanged", "CursorMoved" },
		border_chars = {
			top_left = "┌",
			top_right = "┐",
			bottom_left = "└",
			bottom_right = "┘",
			horizontal = "─",
			vertical = "│",
		},
		show_borders = false,
	},
}
