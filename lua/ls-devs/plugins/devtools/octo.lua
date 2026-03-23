-- ── octo.nvim ────────────────────────────────────────────────────────────
-- Purpose : GitHub PR review and issue management inside Neovim
-- Trigger : cmd = Octo
-- Note    : Uses snacks as the picker backend (matches the existing picker
--           setup). File panel and thread panels open as floats where possible.
--           Requires GITHUB_TOKEN or gh CLI authentication.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"pwntester/octo.nvim",
	cmd = { "Octo" },
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	opts = {
		-- ── Picker backend ────────────────────────────────────────────────
		picker = "snacks",
		picker_config = {
			snacks = {
				use_emojis = true,
			},
		},
		-- ── UI / icons ────────────────────────────────────────────────────
		use_local_fs = false,
		enable_builtin = true,
		default_remote = { "upstream", "origin" },
		right_bubble_delimiter = "",
		left_bubble_delimiter = "",
		comment_icon = "▎",
		outdated_icon = "󰅒 ",
		resolved_icon = " ",
		timeline_icon = "◆",
		timeline_marker = "",
		user_icon = " ",
		reaction_viewer_hint_icon = "",
		create_remote_branch = true,
		-- ── File panel ────────────────────────────────────────────────────
		file_panel = {
			size = 10,
			use_icons = true,
		},
		-- ── Review ────────────────────────────────────────────────────────
		reviews = {
			auto_show_threads = true,
		},
		ui = {
			use_signcolumn = true,
		},
	},
	---@param _ LazyPlugin
	---@param opts table
	config = function(_, opts)
		require("octo").setup(opts)
	end,
	keys = {
		{
			"<leader>Op",
			"<cmd>Octo pr list<CR>",
			desc = "Octo PR List",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Oi",
			"<cmd>Octo issue list<CR>",
			desc = "Octo Issue List",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Or",
			"<cmd>Octo review start<CR>",
			desc = "Octo Review Start",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Os",
			"<cmd>Octo pr search<CR>",
			desc = "Octo PR Search",
			noremap = true,
			silent = true,
		},
		{
			"<leader>Oc",
			"<cmd>Octo pr create<CR>",
			desc = "Octo PR Create",
			noremap = true,
			silent = true,
		},
	},
}
