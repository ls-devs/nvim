-- ── lspsaga ───────────────────────────────────────────────────────────────
-- Purpose : Enhanced LSP UI — hover, rename, diagnostics, outline, call hierarchy
-- Trigger : LspAttach
-- ──────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	opts = {
		lightbulb = {
			enable = true,
			enable_in_insert = false,
			sign = false,
			virtual_text = true,
		},
		symbol_in_winbar = {
			-- Winbar breadcrumb is off; enabled per-project if needed
			enable = false,
			separator = "  ",
			ignore_patterns = {},
			hide_keyword = true,
			show_file = false,
			folder_level = 0,
			respect_root = true,
			color_mode = true,
			border_follow = false,
			winblend = 0,
		},
		hover = {
			border_follow = false,
			max_height = 0.5,
		},
		diagnostic = {
			border_follow = false,
		},
		rename = {
			-- Open rename prompt with cursor at end, not with text pre-selected
			in_select = false,
			keys = {
				quit = "<C-k>",
				exec = "<CR>",
				select = "x",
			},
		},
		ui = {
			title = true,
			border = "rounded",
			winblend = 0,
			expand = "",
			collapse = "",
			code_action = "💡",
			incoming = " ",
			outgoing = " ",
			hover = " ",
		},
		beacon = {
			enable = true,
			frequency = 7, -- number of cursor flashes when jumping to a diagnostic/location
		},
	},
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	keys = {
		{
			"gh",
			"<cmd>Lspsaga finder<CR>",
			desc = "LSPSaga Finder",
			silent = true,
			noremap = true,
		},
		{
			"<leader>ca",
			"<cmd>Lspsaga code_action<CR>",
			desc = "LSPSaga Code Actions",
			silent = true,
			noremap = true,
		},
		{
			"<leader>rn",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			expr = true,
			desc = "Rename (Live Preview)",
		},
		{
			"<leader>rnw",
			"<cmd>Lspsaga rename ++project<CR>",
			desc = "LSPSaga Rename Workspace",
			silent = true,
			noremap = true,
		},
		{
			"gp",
			"<cmd>Lspsaga peek_definition<CR>",
			desc = "LSPSaga Peek Definition",
			silent = true,
			noremap = true,
		},
		{
			"gd",
			"<cmd>Lspsaga goto_definition<CR>",
			desc = "LSPSaga Goto Definition",
			silent = true,
			noremap = true,
		},
		{
			"td",
			"<cmd>Lspsaga peek_type_definition<CR>",
			desc = "LSPSaga Peek Type Definition",
			silent = true,
			noremap = true,
		},
		{
			"gt",
			"<cmd>Lspsaga goto_type_definition<CR>",
			desc = "LSPSaga Goto Type Definition",
			silent = true,
			noremap = true,
		},
		{
			"<leader>dl",
			"<cmd>Lspsaga show_line_diagnostics<CR>",
			desc = "LSPSaga Show Line Diagnostics",
			silent = true,
			noremap = true,
		},
		{
			"<leader>db",
			"<cmd>Lspsaga show_buf_diagnostics<CR>",
			desc = "LSPSaga Show Buf Diagnostics",
			silent = true,
			noremap = true,
		},
		{
			"<leader>dw",
			"<cmd>Lspsaga show_workspace_diagnostics<CR>",
			desc = "LSPSaga Show Workspace Diagnostics",
			silent = true,
			noremap = true,
		},
		{
			"<leader>dc",
			"<cmd>Lspsaga show_cursor_diagnostics<CR>",
			desc = "LSPSaga Show Cursor Diagnostics",
			silent = true,
			noremap = true,
		},
		{
			"[d",
			"<cmd>Lspsaga diagnostic_jump_prev<CR>",
			desc = "LSPSaga Diagnostic Jump Prev",
			silent = true,
			noremap = true,
		},
		{
			"]d",
			"<cmd>Lspsaga diagnostic_jump_next<CR>",
			desc = "LSPSaga Diagnostic Jump Next",
			silent = true,
			noremap = true,
		},
		{
			"<leader>lo",
			"<cmd>Lspsaga outline<CR>",
			desc = "LSPSaga Outline",
			silent = true,
			noremap = true,
		},
		{
			-- Routes through CustomHover (handles edge cases) before falling
			-- back to Lspsaga hover_doc
			"K",
			require("ls-devs.utils.custom_functions").CustomHover,
			desc = "LSP Hover Doc",
			silent = true,
			noremap = true,
		},
		{
			"<leader>K",
			"<cmd>Lspsaga hover_doc ++keep<CR>",
			desc = "LSPSaga Hover Doc Keep",
			silent = true,
			noremap = true,
		},
		{
			"<leader>ci",
			"<cmd>Lspsaga incoming_calls<CR>",
			desc = "LSPSaga Incoming Calls",
			silent = true,
			noremap = true,
		},
		{
			"<leader>co",
			"<cmd>Lspsaga outgoing_calls<CR>",
			desc = "LSPSaga Outgoing Calls",
			silent = true,
			noremap = true,
		},
		{
			"gi",
			"<cmd>Lspsaga finder imp<CR>",
			desc = "LSPSaga Go To Implementation",
			silent = true,
			noremap = true,
		},

	},
}
