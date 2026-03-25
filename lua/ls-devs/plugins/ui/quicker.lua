-- ── quicker.nvim ─────────────────────────────────────────────────────────
-- Purpose : Improved quickfix UI — treesitter/LSP highlights, editable
--           buffer (edit entries then :w to apply across files), context
--           lines expansion (<leader>qe / <leader>qc), file-grouped headers.
-- Trigger : ft = qf (same as nvim-bqf — both coexist fine)
-- Note    : nvim-bqf owns preview float + fzf filter;
--           quicker owns display polish + editing + context expansion.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"stevearc/quicker.nvim",
	ft = "qf",
	---@module "quicker"
	---@type quicker.SetupOptions
	opts = {
		opts = {
			buflisted = false,
			number = false,
			relativenumber = false,
			signcolumn = "auto",
			winfixheight = true,
			wrap = false,
		},
		edit = {
			enabled = true,
			autosave = "unmodified",
		},
		highlight = {
			treesitter = true,
			lsp = true,
			load_buffers = false,
		},
		follow = { enabled = false },
		constrain_cursor = true,
		trim_leading_whitespace = "common",
		type_icons = {
			E = "󰅚 ",
			W = "󰀪 ",
			I = " ",
			N = " ",
			H = " ",
		},
		borders = {
			vert = "┃",
			strong_header = "━",
			strong_cross = "╋",
			strong_end = "┫",
			soft_header = "╌",
			soft_cross = "╂",
			soft_end = "┨",
		},
		keys = {
			{ ">", "<cmd>lua require('quicker').expand()<CR>", desc = "Expand quickfix context" },
			{ "<", "<cmd>lua require('quicker').collapse()<CR>", desc = "Collapse quickfix context" },
		},
	},
}
