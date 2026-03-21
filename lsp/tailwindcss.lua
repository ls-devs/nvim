-- ── lsp/tailwindcss ───────────────────────────────────────────────────────
-- Server  : tailwindcss-language-server
-- Language: HTML, CSS, JS/TS, and Tailwind-enabled templates
-- Config  : root_dir restricted to projects containing a tailwind.config.* file
-- Note    : Prevents the server from activating in non-Tailwind projects
-- ──────────────────────────────────────────────────────────────────────────
return {
	-- Only start the server when a Tailwind config file is present at the root;
	-- without this restriction it can activate in any JS/TS project
	root_dir = require("lspconfig.util").root_pattern(
		"tailwind.config.js",
		"tailwind.config.cjs",
		"tailwind.config.mjs",
		"tailwind.config.ts"
	),
}
