---@diagnostic disable: undefined-global
-- ── ssr.nvim ─────────────────────────────────────────────────────────────
-- Purpose : Structural Search & Replace — search by code shape (AST), not
--           text. Use $wildcard placeholders to match any expression and
--           reference it in the replacement.
--           Example: `foo($a, $b)` → `bar($b, $a)` across all call sites.
-- Trigger : keys only (lazy)
-- Complements: grug-far (text/regex, project-wide) — ssr is AST-aware,
--              buffer-scoped.
-- Keymaps : <leader>ss  — open SSR float on cursor / visual selection
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"cshuaimin/ssr.nvim",
	keys = {
		{
			"<leader>ss",
			function()
				require("ssr").open()
			end,
			mode = { "n", "x" },
			desc = "Structural Search & Replace",
		},
	},
	opts = {
		border = "rounded",
		min_width = 50,
		min_height = 5,
		max_width = 120,
		max_height = 25,
		adjust_window = true,
		keymaps = {
			close = "q",
			next_match = "n",
			prev_match = "N",
			replace_confirm = "<cr>",
			replace_all = "<leader><cr>",
		},
	},
}
