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
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
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
telescope.load_extension('fzf')
vim.keymap.set("n", "<leader>mf", telescope.extensions.media_files.media_files, {})
