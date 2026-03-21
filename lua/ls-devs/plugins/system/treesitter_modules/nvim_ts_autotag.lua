-- ── nvim-ts-autotag ──────────────────────────────────────────────────────
-- Purpose : Auto-close and auto-rename HTML/JSX/template tags via treesitter
-- Trigger : ft html/js/ts/jsx/tsx/vue/svelte/php/astro and more (see list)
-- Note    : Loaded as a standalone spec; the autotag opts in treesitter.lua
--           mirror the ft list defined here.
-- ─────────────────────────────────────────────────────────────────────────
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
		"tsx",
		"jsx",
		"rescript",
		"xml",
		"php",
		"markdown",
		"astro",
		"glimmer",
		"handlebars",
		"hbs",
	},
}
