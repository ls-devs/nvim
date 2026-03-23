-- ── nvim-coverage ────────────────────────────────────────────────────────
-- Purpose : Render test coverage annotations (covered / uncovered / partial)
--           in the sign column after running tests.
-- Trigger : cmd = Coverage* (load on demand)
-- Pairs with: neotest — run tests with <leader>Tf/Tr, then <leader>cv to overlay
-- Supports: coverage.py (Python), lcov (Jest/Vitest/C), cobertura (XML)
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"andythigpen/nvim-coverage",
	cmd = {
		"Coverage",
		"CoverageSummary",
		"CoverageToggle",
		"CoverageLoad",
		"CoverageShow",
		"CoverageHide",
		"CoverageClear",
	},
	opts = {
		commands = true,
		-- ── Highlight colours (catppuccin-mocha palette) ───────────────────
		highlights = {
			covered = { fg = "#a6e3a1" }, -- green
			uncovered = { fg = "#f38ba8" }, -- red
			partial = { fg = "#f9e2af" }, -- yellow
		},
		-- ── Gutter signs ──────────────────────────────────────────────────
		signs = {
			covered = { hl = "CoverageCovered", text = "▎" },
			uncovered = { hl = "CoverageUncovered", text = "▎" },
			partial = { hl = "CoveragePartial", text = "▎" },
		},
		summary = {
			min_coverage = 80.0,
		},
		-- ── Language-specific config ───────────────────────────────────────
		lang = {
			python = {
				coverage_file = ".coverage",
				coverage_command = "coverage json --fail-under=0 -q -o -",
			},
			javascript = {
				coverage_file = "coverage/coverage-final.json",
			},
			typescript = {
				coverage_file = "coverage/coverage-final.json",
			},
		},
	},
	keys = {
		{
			"<leader>cv",
			"<cmd>CoverageToggle<CR>",
			desc = "Coverage Toggle",
			noremap = true,
			silent = true,
		},
		{
			"<leader>cV",
			"<cmd>CoverageSummary<CR>",
			desc = "Coverage Summary",
			noremap = true,
			silent = true,
		},
		{
			"<leader>cL",
			"<cmd>CoverageLoad<CR>",
			desc = "Coverage Load",
			noremap = true,
			silent = true,
		},
	},
}
