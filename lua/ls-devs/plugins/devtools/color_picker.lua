-- ── ccc.nvim ─────────────────────────────────────────────────────────────
-- Purpose : Interactive slider-based colour picker and format converter
-- Trigger : cmd only — CccPick / CccConvert
-- Note    : ccc's *highlighter* was retired in favour of ui/colorizer.lua
--           (catgoose/nvim-colorizer.lua): ccc has had no upstream commit in
--           12 months and its LSP highlighter duplicated Neovim 0.12+'s
--           built-in `vim.lsp.document_color`.
--           ccc is kept only for `:CccPick`, whose slider UI has no
--           equivalent in colorizer or in core, and is now loaded strictly on
--           demand instead of on every CSS/HTML/JSX buffer.
--           The picker opens as a rounded-border float at the cursor.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"uga-rosa/ccc.nvim",
	cmd = { "CccPick", "CccConvert" },
	opts = {
		default_color = "#ffffff",
		preserve = false,
		save_on_quit = false,
		-- ── Picker float ──────────────────────────────────────────────────
		float_win_config = {
			style = "minimal",
			relative = "cursor",
			border = "rounded",
		},
		auto_close = true,
		alpha_show = "show",
		-- Highlighting is owned by nvim-colorizer.lua
		highlighter = {
			auto_enable = false,
			lsp = false,
		},
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("ccc").setup(opts)
	end,
	keys = {
		{
			"<leader>cp",
			"<cmd>CccPick<CR>",
			desc = "Color Picker",
			noremap = true,
			silent = true,
		},
		{
			"<leader>cC",
			"<cmd>CccConvert<CR>",
			desc = "Color Convert",
			noremap = true,
			silent = true,
		},
	},
}
