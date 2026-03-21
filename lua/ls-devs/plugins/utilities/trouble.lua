-- ── trouble.nvim ──────────────────────────────────────────────────────────
-- Purpose : Pretty diagnostics list panel (v3 API)
-- Trigger : cmd — Trouble; keys — <leader>v
-- Note    : Uses `Trouble diagnostics toggle` (v3 API); TroubleToggle is deprecated v2
-- ─────────────────────────────────────────────────────────────────────────
return {
	"folke/trouble.nvim",
	dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
	opts = {
		-- Automatically close the panel when the diagnostics list becomes empty
		auto_close = true,
		auto_preview = false,
		use_diagnostic_signs = true,
		keys = {
			-- Rebind `l` (normally move-right) to fold toggle inside the trouble buffer
			["l"] = "fold_toggle",
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>v",
			"<cmd>Trouble diagnostics toggle<CR>",
			desc = "Trouble Toggle",
			silent = true,
			noremap = true,
		},
	},
}
