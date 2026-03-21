-- ── telescope-emoji.nvim ─────────────────────────────────────────────────
-- Purpose : Browse and insert emoji via Telescope
-- Trigger : keys <leader>fe
-- Note    : The picker action (yank selected emoji to the * register) is
--           configured in telescope.lua's extensions.emoji table, not here.
-- ─────────────────────────────────────────────────────────────────────────
return {
	"xiyaowong/telescope-emoji.nvim",
	keys = {
		{
			"<leader>fe",
			"<cmd>Telescope emoji<CR>",
			desc = "Telescope Emoji",
			noremap = true,
			silent = true,
		},
	},
	config = function()
		require("telescope").load_extension("emoji")
	end,
}
