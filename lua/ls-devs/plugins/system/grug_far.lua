-- ── grug-far ──────────────────────────────────────────────────────────────
-- Purpose : Search & replace UI powered by ripgrep
-- Trigger : GrugFar cmd, <leader>sr / <leader>sw keymaps
-- Note    : Opens in a centered floating window (85 % of screen).
--           ripgrep engine with --max-depth 6 and --one-file-system flags.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	keys = {
		{
			"<leader>sr",
			function()
				require("grug-far").open({ transient = true })
			end,
			desc = "GrugFar Search & Replace",
			noremap = true,
			silent = true,
		},
		{
			"<leader>sw",
			function()
				require("grug-far").open({
					transient = true,
					prefills = { search = vim.fn.expand("<cword>") },
				})
			end,
			desc = "GrugFar Search Word",
			noremap = true,
			silent = true,
		},
		{
			"<leader>sf",
			function()
				require("grug-far").open({
					transient = true,
					prefills = { paths = vim.fn.expand("%") },
				})
			end,
			desc = "GrugFar Search Current File",
			noremap = true,
			silent = true,
		},
	},
	opts = {
		headerMaxWidth = 80,
		engine = "ripgrep",
		engines = {
			ripgrep = {
				extraArgs = "--max-depth 6 --one-file-system", -- limit traversal depth and avoid crossing filesystem boundaries
			},
		},
		spinnerStates = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
		icons = {
			fileIconsProvider = "mini.icons",
		},
	},
}
