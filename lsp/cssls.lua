-- ── lsp/cssls ─────────────────────────────────────────────────────────────
-- Server  : vscode-css-language-server (cssls)
-- Language: CSS, SCSS, Less
-- Config  : unknownAtRules set to "ignore" for all dialects
-- Note    : Suppresses false-positive warnings from Tailwind directives
--           (@apply, @layer, @screen, @variants, etc.)
-- ──────────────────────────────────────────────────────────────────────────
return {
	settings = {
		css = {
			lint = {
				-- Tailwind and other utility frameworks use non-standard at-rules
				unknownAtRules = "ignore",
			},
		},
		scss = {
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
}
