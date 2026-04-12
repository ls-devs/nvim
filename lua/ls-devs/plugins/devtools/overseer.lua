-- ── overseer ─────────────────────────────────────────────────────────────
-- Purpose : Task runner / build system overlay for Neovim
-- Trigger : cmd = OverseerRun / OverseerToggle / OverseerBuild / OverseerOpen / OverseerInfo
-- Note    : Task form, output, preview and help windows all use rounded borders.
--           The preview float and help popup (?) have no border config options so
--           both are monkey-patched: preview via sidebar.toggle_preview, help via
--           keymap_util.show_help injecting border = "rounded" into nvim_open_win.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"stevearc/overseer.nvim",
	config = function(_, opts)
		require("overseer").setup(opts)

		-- Patch the preview float — border is never set by sidebar.toggle_preview
		local sidebar = require("overseer.task_list.sidebar")
		local orig_toggle = sidebar.toggle_preview
		sidebar.toggle_preview = function(self, ...)
			-- Custom floating preview with border
			local task = self:get_selected_task()
			if not task then
				return
			end
			if self._preview_win and vim.api.nvim_win_is_valid(self._preview_win) then
				vim.api.nvim_win_close(self._preview_win, true)
				self._preview_win = nil
				return
			end
			local lines = vim.split(task:get_preview(), "\n")
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			local width = math.max(
				60,
				math.min(
					120,
					math.max(unpack(vim.tbl_map(function(l)
						return #l
					end, lines)))
				)
			)
			local height = math.min(20, #lines)
			local win_opts = {
				relative = "editor",
				row = math.floor((vim.o.lines - height) / 2),
				col = math.floor((vim.o.columns - width) / 2),
				width = width,
				height = height,
				style = "minimal",
				border = "rounded",
			}
			self._preview_win = vim.api.nvim_open_win(buf, true, win_opts)
		end

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
		-- note: "preview" is not a valid top-level key in overseer config; removed
		task_list = {
			-- Lock width to exactly 40 so layout.calculate_width() returns 40 immediately
			-- on the first nvim_win_set_width call in window.lua, preventing any
			-- one-frame flash before our WinResized/FileType correction could run.
			min_width = 40,
			max_width = 40,
			win_opts = {
				winfixwidth = true,
				winfixheight = true,
			},
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
		-- Temporarily disable focus.nvim around the toggle to prevent it from
		-- golden-ratio-resizing the new split before winfixwidth is set —
		-- mirrors the neo_tree_window_before/after_open event handlers in neo_tree.lua.
		{
			"<leader>ot",
			function()
				vim.g.focus_disable = true
				vim.cmd("OverseerToggle left")
				vim.schedule(function()
					vim.g.focus_disable = false
				end)
			end,
			desc = "Overseer Toggle",
			noremap = true,
			silent = true,
		},
	},
}
