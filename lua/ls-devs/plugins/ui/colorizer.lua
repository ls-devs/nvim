-- ── nvim-colorizer.lua ───────────────────────────────────────────────────
-- Purpose : Inline colour highlighting for CSS/SCSS/HTML/JS/TS/Vue/Svelte
-- Trigger : ft — only the filetypes that actually carry colour literals
-- Note    : catgoose/nvim-colorizer.lua is the maintained successor of
--           norcalli/nvim-colorizer.lua. It replaces ccc.nvim's highlighter,
--           which had no upstream commit in 12 months; ccc is kept in
--           devtools/color_picker.lua purely as an on-demand picker.
--           Neovim 0.12+ enables `vim.lsp.document_color` by default, which
--           would double-highlight the same ranges. colorizer turns it off
--           per buffer on attach via `display.disable_document_color`
--           (default true), so no LspAttach autocmd is needed here.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"catgoose/nvim-colorizer.lua",
	ft = {
		"css",
		"scss",
		"sass",
		"less",
		"html",
		"htmldjango",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"astro",
		"vue",
		"svelte",
	},
	cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
	opts = {
		filetypes = {
			"css",
			"scss",
			"sass",
			"less",
			"html",
			"htmldjango",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"astro",
			"vue",
			"svelte",
		},
		options = {
			-- `css` preset covers names, every hex form, rgb(), hsl(), oklch()
			-- and var() custom properties in one switch.
			parsers = {
				css = true,
				css_fn = true,
				tailwind = { enable = true, lsp = true },
			},
			display = {
				mode = "background",
			},
			-- Only repaint the focused buffer
			always_update = false,
		},
	},
	keys = {
		{
			"<leader>cH",
			"<cmd>ColorizerToggle<CR>",
			desc = "Color Highlighter Toggle",
			noremap = true,
			silent = true,
		},
	},
}
