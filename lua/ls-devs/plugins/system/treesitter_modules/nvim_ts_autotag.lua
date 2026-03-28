-- ── nvim-ts-autotag ──────────────────────────────────────────────────────
-- Purpose : Auto-close and auto-rename HTML/JSX/template tags via treesitter
-- Trigger : ft html/js/ts/jsx/tsx/vue/svelte/php/astro and more (see list)
-- Note    : Configured via its own opts (new API); the deprecated autotag block
--           in treesitter.lua has been removed.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"windwp/nvim-ts-autotag",
	ft = {
		"html",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"rescript",
		"xml",
		"php",
		"markdown",
		"astro",
		"glimmer",
		"handlebars",
		"hbs",
	},
	opts = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	},
}
