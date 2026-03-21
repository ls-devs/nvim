-- ── bigfile ───────────────────────────────────────────────────────────────
-- Purpose : Disables heavy features (treesitter, LSP, indent, etc.) for large files
-- Trigger : BufReadPre
-- Note    : filesize is in MB; previously used a broken cond — now event-based
-- ─────────────────────────────────────────────────────────────────────────
return {
	"LunarVim/bigfile.nvim",
	event = "BufReadPre",
	config = function()
		require("bigfile").setup({
			filesize = 6, -- threshold in MB; above this, heavy features like treesitter and LSP are disabled
		})
	end,
}
