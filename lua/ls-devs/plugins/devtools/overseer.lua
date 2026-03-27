-- ── overseer ─────────────────────────────────────────────────────────────
-- Purpose : Task runner / build system overlay for Neovim
-- Trigger : cmd = OverseerRun / OverseerToggle / OverseerBuild / OverseerOpen / OverseerInfo
-- Note    : Task form, output and help windows all use rounded borders.
--           The help popup (?) has no border config option so show_help is
--           monkey-patched to inject border = "rounded" into nvim_open_win.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"stevearc/overseer.nvim",
	config = function(_, opts)
		require("overseer").setup(opts)

		-- Patch the help popup — hardcoded in keymap_util with no border option
		local keymap_util = require("overseer.keymap_util")
		local orig = keymap_util.show_help
		keymap_util.show_help = function(maps)
			local orig_open = vim.api.nvim_open_win
			---@diagnostic disable-next-line: duplicate-set-field
			vim.api.nvim_open_win = function(buf, enter, cfg)
				if cfg.relative == "editor" and cfg.style == "minimal" then
					cfg.border = "rounded"
				end
				return orig_open(buf, enter, cfg)
			end
			orig(maps)
			vim.api.nvim_open_win = orig_open
		end
	end,
	opts = {
		form = {
			border = "rounded",
			win_opts = {
				winblend = 0,
			},
		},
		task_win = {
			border = "rounded",
			win_opts = {
				winblend = 0,
			},
		},
		preview = {
			border = "rounded",
			win_opts = {
				winblend = 0,
			},
		},
		task_list = {
			keymaps = {
				["?"] = "keymap.show_help",
				["g?"] = "keymap.show_help",
				["<CR>"] = "keymap.run_action",
				["dd"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Dispose task" },
				["<C-e>"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
				["o"] = "keymap.open",
				["<C-v>"] = { "keymap.open", opts = { dir = "vsplit" }, desc = "Open task output in vsplit" },
				["<C-s>"] = { "keymap.open", opts = { dir = "split" }, desc = "Open task output in split" },
				["<C-f>"] = { "keymap.open", opts = { dir = "float" }, desc = "Open task output in float" },
				["<C-q>"] = {
					"keymap.run_action",
					opts = { action = "open output in quickfix" },
					desc = "Open quickfix",
				},
				["p"] = "keymap.toggle_preview",
				["{"] = "keymap.prev_task",
				["}"] = "keymap.next_task",
				["<C-k>"] = "keymap.scroll_output_up",
				["<C-j>"] = "keymap.scroll_output_down",
			},
		},
	},
	cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild", "OverseerOpen", "OverseerInfo" },
	keys = {
		-- <leader>or — open the task picker and run a task
		{
			"<leader>or",
			"<cmd>OverseerRun<CR>",
			desc = "Overseer Run",
			noremap = true,
			silent = true,
		},
		-- <leader>ot — toggle the task list panel (docked left)
		{
			"<leader>ot",
			"<cmd>OverseerToggle left<CR>",
			desc = "Overseer Toggle",
			noremap = true,
			silent = true,
		},
	},
}
