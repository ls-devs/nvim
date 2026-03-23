-- ── ccc.nvim ─────────────────────────────────────────────────────────────
-- Purpose : Inline color picker and highlighter for CSS/SCSS/HTML/JS/TS work
-- Trigger : ft = css/scss/sass/less/html/jsx/tsx/astro/vue/svelte (auto-load
--           for color highlighting); cmd CccPick / CccHighlighterToggle
-- Note    : The picker opens as a rounded-border float at the cursor.
--           Auto-highlighting is on by default for supported filetypes.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"uga-rosa/ccc.nvim",
	ft = {
		"css",
		"scss",
		"sass",
		"less",
		"html",
		"htmldjango",
		"javascriptreact",
		"typescriptreact",
		"astro",
		"vue",
		"svelte",
	},
	cmd = {
		"CccPick",
		"CccConvert",
		"CccHighlighterEnable",
		"CccHighlighterDisable",
		"CccHighlighterToggle",
	},
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
		-- ── Color highlighter ─────────────────────────────────────────────
		highlighter = {
			auto_enable = true,
			max_byte = 100 * 1024, -- skip files > 100 KB to avoid slowdowns
			lsp = true, -- use LSP color info when available
			filetypes = {
				"css",
				"scss",
				"sass",
				"less",
				"html",
				"htmldjango",
				"javascriptreact",
				"typescriptreact",
				"astro",
				"vue",
				"svelte",
			},
		},
	},
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
			"<leader>cH",
			"<cmd>CccHighlighterToggle<CR>",
			desc = "Color Highlighter Toggle",
			noremap = true,
			silent = true,
		},
	},
}
