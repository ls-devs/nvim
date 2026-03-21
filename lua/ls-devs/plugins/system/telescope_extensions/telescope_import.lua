-- ── telescope-import.nvim ────────────────────────────────────────────────
-- Purpose : Fuzzy-search and insert import statements via Telescope
-- Trigger : keys <leader>fi
-- Note    : Custom regex + TS/JS filetype config lives in telescope.lua's
--           extensions.import table. Imports are inserted at top of file.
-- ─────────────────────────────────────────────────────────────────────────
return {
	"piersolenski/telescope-import.nvim",
	keys = {
		{
			"<leader>fi",
			"<cmd>Telescope import<CR>",
			desc = "Telescope Import",
			noremap = true,
			silent = true,
		},
	},
	config = function()
		require("telescope").load_extension("import")
	end,
}
