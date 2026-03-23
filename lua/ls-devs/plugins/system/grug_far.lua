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
				-- Open a floating window then let grug-far occupy it via "enew" (no split).
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.85),
					col = math.floor(vim.o.columns * 0.075),
					row = math.floor(vim.o.lines * 0.075),
					style = "minimal",
					border = "rounded",
				})
				require("grug-far").open({ windowCreationCommand = "enew" })
			end,
			desc = "GrugFar Search & Replace",
			noremap = true,
			silent = true,
		},
		{
			"<leader>sw",
			function()
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.85),
					col = math.floor(vim.o.columns * 0.075),
					row = math.floor(vim.o.lines * 0.075),
					style = "minimal",
					border = "rounded",
				})
				require("grug-far").open({
					windowCreationCommand = "enew",
					prefills = { search = vim.fn.expand("<cword>") },
				})
			end,
			desc = "GrugFar Search Word",
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
			fileIconsProvider = "nvim-web-devicons",
		},
	},
}
