-- ── nerdy.nvim ───────────────────────────────────────────────────────────
-- Purpose : Browse and insert Nerd Font icons via Telescope
-- Trigger : keys <leader>fg
-- Note    : Requires dressing.nvim for enhanced vim.ui.select() rendering.
-- ─────────────────────────────────────────────────────────────────────────
return {
	"2kabhishek/nerdy.nvim",
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>fg",
			"<Cmd>Telescope nerdy<CR>",
			desc = "Telescope Nerdy",
			noremap = true,
			silent = true,
		},
	},
	config = function()
		require("telescope").load_extension("nerdy")
	end,
}
