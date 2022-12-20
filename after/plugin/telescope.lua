local telescope = require("telescope")
local actions = require("telescope.actions")

if not telescope then
	return
end

if not actions then
	return
end

telescope.setup({
	defaults = {
		file_ignore_patterns = {
			".git/",
			"node_modules/*",
		},
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
			},
			n = {
				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
			},
		},
	},
	extensions = {
		media_files = {
			-- filetypes whitelist
			filetypes = { "png", "webp", "jpg", "jpeg", "gif", "mp4", "pdf" },
		},
	},
	pickers = {
		find_files = {
			theme = "dropdown",
			previewer = false,
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
		},
	},
})
telescope.load_extension("media_files")

vim.keymap.set("n", "<leader>mf", telescope.extensions.media_files.media_files, {})
