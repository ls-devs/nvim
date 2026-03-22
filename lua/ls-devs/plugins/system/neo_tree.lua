-- ── neo-tree.nvim ────────────────────────────────────────────────────────
-- Purpose : File explorer — float when called from the dashboard, left
--           sidebar (VS Code style) when a real buffer is already open.
-- Trigger : cmd Neotree, keys <leader>e
-- Behavior: <leader>e from snacks_dashboard → Neotree float reveal
--           <leader>e from any other buffer  → Neotree left reveal toggle
-- Note    : open_and_clear_filter is intentionally defined in both top-level
--           commands and filesystem.commands — each source scope needs its own
--           copy because top-level commands don't apply inside filesystem.
-- ─────────────────────────────────────────────────────────────────────────

return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = { "Neotree" },
	keys = {
		{
			"<leader>e",
			function()
				local ft = vim.bo.filetype
				local is_dashboard = ft == "snacks_dashboard" or ft == "starter"
				if is_dashboard then
					vim.cmd("Neotree float reveal")
				elseif ft == "neo-tree" then
					-- Already inside neo-tree — close it (same as pressing q)
					vim.cmd("Neotree close")
				else
					-- Toggle: close if already open on the left, otherwise open.
					vim.cmd("Neotree left toggle reveal")
				end
			end,
			desc = "NeoTree (float on dashboard / sidebar on buffer)",
			silent = true,
			noremap = true,
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		-- Snap cursor to the first character of the filename on every move.
		-- Neo-tree renders lines as: [indent spaces][icon][space][name]
		-- Strategy: scan left-to-right for the last [multi-byte char][space] pair
		-- (that's always the icon + space); the char after the space is the filename.
		local function name_col(line)
			local b = 1
			while b <= #line do
				local byte = line:byte(b)
				local clen = (byte >= 0xF0 and 4) or (byte >= 0xE0 and 3) or (byte >= 0xC0 and 2) or 1
				if clen > 1 then
					local after = b + clen
					if after <= #line and line:byte(after) == 0x20 then
						-- Scan past all spaces following this glyph (handles empty
						-- folder icons which produce two consecutive spaces).
						local name_start = after + 1
						while name_start <= #line and line:byte(name_start) == 0x20 do
							name_start = name_start + 1
						end
						-- Accept only if the target is ASCII (< 0x80): indent markers
						-- and icons always lead to another glyph (\xc2+) or the filename
						-- (ASCII). Right-side git/diagnostic glyphs are themselves non-ASCII
						-- so they are never a valid target here.
						if name_start <= #line and line:byte(name_start) < 0x80 then
							return name_start - 1 -- 0-indexed col of first filename char
						end
					end
				end
				b = b + clen
			end
			-- Fallback: first non-blank char (handles root items with no icon)
			local first = line:find("%S")
			return first and first - 1 or 0
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "neo-tree",
			callback = function(ev)
				local group = vim.api.nvim_create_augroup("neotree_cursor_snap_" .. ev.buf, { clear = true })
				local lock = false
				vim.api.nvim_create_autocmd("CursorMoved", {
					buffer = ev.buf,
					group = group,
					callback = function()
						if lock then
							return
						end
						local ok, pos = pcall(vim.api.nvim_win_get_cursor, 0)
						if not ok then
							return
						end
						local row, col = pos[1], pos[2]
						local line = vim.api.nvim_get_current_line()
						local target = name_col(line)
						if col ~= target then
							lock = true
							pcall(vim.api.nvim_win_set_cursor, 0, { row, target })
							lock = false
						end
					end,
				})
			end,
		})
	end,
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
		sort_case_insensitive = true,
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				highlight = "NeoTreeIndentMarker",
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰉖",
				folder_empty_open = "󰷏",
				default = "",
				highlight = "NeoTreeFileIcon",
			},
			modified = {
				symbol = "[+]",
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					added = "✚",
					modified = "",
					deleted = "󰛌",
					renamed = "󰁕",
					untracked = "",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
				},
			},
			file_size = {
				enabled = true,
				required_width = 64,
			},
			type = {
				enabled = true,
				required_width = 122,
			},
			last_modified = {
				enabled = true,
				required_width = 88,
			},
			created = {
				enabled = true,
				required_width = 110,
			},
			symlink_target = {
				enabled = false,
			},
		},
		commands = {
			open_and_clear_filter = function(state)
				local node = state.tree:get_node()
				if node and node.type == "file" then
					local cmds = require("neo-tree.sources.filesystem.commands")
					cmds.open(state)
					cmds.clear_filter(state)
					require("neo-tree.command").execute({ action = "close" })
				end
			end,
		},
		window = {
			-- Default position; overridden per-call in the <leader>e keymap.
			position = "float",
			-- Width used when opened as a left sidebar.
			width = 40,
			popup = {
				size = { height = "35", width = "90" },
				position = "50%",
			},
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = "none",
				["<2-LeftMouse>"] = "open",
				["l"] = function(state)
					local node = state.tree:get_node()
					if node.type == "message" then
						require("neo-tree.sources.filesystem.commands").toggle_hidden(state)
					else
						require("neo-tree.sources.filesystem.commands").open(state)
					end
				end,
				["<CR>"] = function(state)
					local node = state.tree:get_node()
					if node.type == "message" then
						require("neo-tree.sources.filesystem.commands").toggle_hidden(state)
					else
						require("neo-tree.sources.filesystem.commands").open(state)
					end
				end,
				["h"] = function(state)
					local node = state.tree:get_node()
					local cmds = require("neo-tree.sources.filesystem.commands")
					if state.filtered_items and state.filtered_items.visible then
						cmds.toggle_hidden(state)
					elseif node.type == "directory" and node:is_expanded() then
						cmds.close_node(state)
					else
						cmds.navigate_up(state)
					end
				end,
				["<esc>"] = "close_window",
				["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
				[","] = "focus_preview",
				["S"] = "split_with_window_picker",
				["s"] = "vsplit_with_window_picker",
				["t"] = "open_tabnew",
				["w"] = "open_with_window_picker",
				["C"] = "close_all_subnodes",
				["z"] = "close_all_nodes",
				["Z"] = "expand_all_nodes",
				["o"] = "open_and_clear_filter",
				["a"] = {
					"add",
					config = { show_path = "relative" },
				},
				["m"] = {
					"move",
					config = { show_path = "relative" },
				},
				["A"] = {
					"add_directory",
					config = { show_path = "relative" },
				},
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = {
					"copy",
					config = { show_path = "relative" },
				},
				["q"] = "close_window",
				["<leader>e"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source",
				[">"] = "next_source",
				["i"] = "show_file_details",
			},
		},
		nesting_rules = {},
		filesystem = {
			filtered_items = {
				visible = false,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_hidden = true,
				hide_by_name = {
					"node_modules",
				},
				hide_by_pattern = {},
				always_show = {
					".env",
					".env.example",
					".env.local",
					".env.mocked",
					".env.development",
					".env.integration",
					".env.valdiation",
					".env.production",
					".eslintrc.json",
					".eslintrc.js",
					".prettierrc.json",
					".prettierrc.js",
					".gitignore",
					".dockerignore",
				},
				never_show = {
					".DS_Store",
				},
				never_show_by_pattern = {},
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			group_empty_dirs = false,
			hijack_netrw_behavior = "open_default",
			use_libuv_file_watcher = true,
			window = {
				mappings = {
					["<bs>"] = "navigate_up",
					["r"] = "rename",
					["m"] = {
						"move",
						config = { show_path = "relative" },
					},
					["."] = "set_root",
					["H"] = "toggle_hidden",
					["/"] = "fuzzy_finder",
					["#"] = "fuzzy_sorter",
					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
					["o"] = "open_and_clear_filter",
					["?"] = { "show_help" },
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["og"] = { "order_by_git_status", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
					["<leader>e"] = "close_window",
				},
				fuzzy_finder_mappings = {
					["<down>"] = "move_cursor_down",
					["<C-j>"] = "move_cursor_down",
					["<up>"] = "move_cursor_up",
					["<C-k>"] = "move_cursor_up",
				},
			},
			commands = {
				open_and_clear_filter = function(state)
					local node = state.tree:get_node()
					if node and node.type == "file" then
						local cmds = require("neo-tree.sources.filesystem.commands")
						cmds.open(state)
						cmds.clear_filter(state)
						require("neo-tree.command").execute({ action = "close" })
					end
				end,
			},
		},
		event_handlers = {
			{
				event = "file_opened",
				-- Always close the tree when a file is opened, regardless of mode
				-- (float, sidebar, split, tab, etc.).
				handler = function()
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
			{
				event = "neo_tree_popup_input_ready",
				handler = function()
					vim.cmd("stopinsert")
				end,
			},
		},
		buffers = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			group_empty_dirs = true,
			show_unloaded = true,
			window = {
				mappings = {
					["bd"] = "buffer_delete",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["?"] = { "show_help" },
					["o"] = "open_and_clear_filter",
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
				},
			},
		},
		git_status = {
			window = {
				position = "float",
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
					["?"] = { "show_help" },
					["o"] = "open_and_clear_filter",
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
				},
			},
		},
	},
	dependencies = {
		{ "3rd/image.nvim", lazy = true },
		{ "plenary.nvim", lazy = true },
		{ "nvim-tree/nvim-web-devicons", lazy = true },
		{ "MunifTanjim/nui.nvim", lazy = true },
		{
			"s1n7ax/nvim-window-picker",
			lazy = true,
			opts = {
				hint = "floating-big-letter",
				show_prompt = false,
				picker_config = {
					floating_big_letter = {
						font = "ansi-shadow",
					},
				},
				filter_rules = {
					autoselect_one = true,
					include_current_win = false,
					bo = {
						filetype = {
							"NvimTree",
							"neo-tree",
							"neo-tree-popup",
							"NeoTreeFloat",
							"notify",
							"fidget",
						},
						buftype = { "terminal", "quickfix" },
					},
				},
				highlights = {
					statusline = {
						focused = { fg = "#ededed", bg = "#e35e4f", bold = true },
						unfocused = { fg = "#ededed", bg = "#44cc41", bold = true },
					},
					winbar = {
						focused = { fg = "#ededed", bg = "#e35e4f", bold = true },
						unfocused = { fg = "#ededed", bg = "#44cc41", bold = true },
					},
				},
			},
		},
	},
}
