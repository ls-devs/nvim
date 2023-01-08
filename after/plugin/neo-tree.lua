local neo_tree = require("neo-tree")

neo_tree.setup({
	close_if_last_window = true,
	hide_root_node = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	window = {
		position = "right",
		mappings = {
			["l"] = "open",
			["S"] = "split_with_window_picker",
			["s"] = "vsplit_with_window_picker",
			["w"] = "open_with_window_picker",
		},
	},
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			always_show = {
				".gitignore",
			},
			never_show = {
				".git",
				".DS_Store",
				"lazy-lock.json",
			},
		},
		hijack_netrw_behavior = "open_current",
		follow_current_file = true,
		use_libuv_file_watcher = true,
	},
})
