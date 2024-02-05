return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = { "Neotree" },
	keys = {
		{
			"<leader>e",
			"<cmd>Neotree float reveal<CR>",
			desc = "NeoTreeFloatToggle reveal",
			silent = true,
			noremap = true,
		},
	},
	opts = {
		close_if_last_window = true,
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		enable_normal_mode_for_inputs = true,
		enable_cursor_hijack = true,
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
		sort_case_insensitive = false,
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
				with_expanders = nil,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "",

				default = "*",
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
					added = "",
					modified = "",
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
					local file_path = node:get_id()

					local cmds = require("neo-tree.sources.filesystem.commands")
					cmds.open(state)
					cmds.clear_filter(state)

					require("neo-tree.sources.filesystem").navigate(state, state.path, file_path)
				end
			end,
		},
		window = {
			position = "float",
			width = 40,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = true,
				},
				["<2-LeftMouse>"] = "open",
				["l"] = "open",
				["<esc>"] = "cancel",
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
				["D"] = "fuzzy_finder_directory",
				["#"] = "fuzzy_sorter",
				["a"] = {
					"add",
					config = {
						show_path = "relative",
					},
				},
				["m"] = {
					"move",
					config = {
						show_path = "relative",
					},
				},

				["A"] = {
					"add_directory",
					config = {
						show_path = "relative",
					},
				},
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = {
					"copy",
					config = {
						show_path = "relative",
					},
				},
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source",
				[">"] = "next_source",
				["i"] = "show_file_details",
				["O"] = "system_open",
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
						config = {
							show_path = "relative",
						},
					},
					["."] = "set_root",
					["H"] = "toggle_hidden",
					["/"] = "fuzzy_finder",

					["#"] = "fuzzy_sorter",

					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
					["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["og"] = { "order_by_git_status", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
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
						local file_path = node:get_id()

						local cmds = require("neo-tree.sources.filesystem.commands")
						cmds.open(state)
						cmds.clear_filter(state)

						require("neo-tree.sources.filesystem").navigate(state, state.path, file_path)
					end
				end,
				system_open = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.jobstart({ "xdg-open", path }, { detach = true })
				end,
			},
		},
		event_handlers = {
			{
				event = "neo_tree_window_after_open",
				handler = function(args)
					vim.cmd("set laststatus=0")
				end,
			},
			{
				event = "neo_tree_window_after_close",
				handler = function(args)
					vim.cmd("set laststatus=3")
				end,
			},
			{
				event = "file_opened",
				handler = function()
					require("neo-tree").close_all()
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
					["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
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
					["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
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
		"3rd/image.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
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
						filetype = { "NvimTree", "neo-tree", "neo-tree-popup", "NeoTreeFloat", "notify" },
						buftype = { "terminal", "quickfix" },
					},
				},
				highlights = {
					statusline = {
						focused = {
							fg = "#ededed",
							bg = "#e35e4f",
							bold = true,
						},
						unfocused = {
							fg = "#ededed",
							bg = "#44cc41",
							bold = true,
						},
					},
					winbar = {
						focused = {
							fg = "#ededed",
							bg = "#e35e4f",
							bold = true,
						},
						unfocused = {
							fg = "#ededed",
							bg = "#44cc41",
							bold = true,
						},
					},
				},
			},
		},
	},
}
