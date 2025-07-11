return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local lst = require("telescope").extensions.luasnip
		local luasnip = require("luasnip")

		local function filterDuplicates(array)
			local uniqueArray = {}
			for _, tableA in ipairs(array) do
				local isDuplicate = false
				for _, tableB in ipairs(uniqueArray) do
					if vim.deep_equal(tableA, tableB) then
						isDuplicate = true
						break
					end
				end
				if not isDuplicate then
					table.insert(uniqueArray, tableA)
				end
			end
			return uniqueArray
		end

		local function on_list(options)
			options.items = filterDuplicates(options.items)
			vim.fn.setqflist({}, " ", options)
			vim.cmd("botright copen")
		end

		vim.lsp.buf.references(nil, { on_list = on_list })

		telescope.setup({
			defaults = {
				prompt_prefix = " 🔍 ",
				layout_config = {
					horizontal = {
						preview_width = 0.47,
						prompt_position = "top",
						width = 0.9,
					},
				},
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
						["<A-a>"] = actions.toggle_all,
						["<C-s>"] = actions.select_vertical,
						["<A-k>"] = actions.preview_scrolling_left,
						["<A-l>"] = actions.preview_scrolling_right,
						["<A-f>"] = actions.preview_scrolling_down,
						["<A-b>"] = actions.preview_scrolling_up,
						["<A-h>"] = actions.results_scrolling_left,
						["<A-j>"] = actions.results_scrolling_right,
					},
					n = {
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<A-a>"] = actions.toggle_all,
						["<C-s>"] = actions.select_vertical,
						["<A-k>"] = actions.preview_scrolling_left,
						["<A-l>"] = actions.preview_scrolling_right,
						["<A-f>"] = actions.preview_scrolling_down,
						["<A-b>"] = actions.preview_scrolling_up,
						["<A-h>"] = actions.results_scrolling_left,
						["<A-j>"] = actions.results_scrolling_right,
					},
				},
			},
			extensions = {
				emoji = {
					action = function(emoji)
						vim.fn.setreg("*", emoji.value)
						print([[Press p or "*p to paste this emoji ]] .. emoji.value)
					end,
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				luasnip = {
					search = function(entry)
						return lst.filter_null(entry.context.trigger)
							.. " "
							.. lst.filter_null(entry.context.name)
							.. " "
							.. entry.ft
							.. " "
							.. lst.filter_description(entry.context.name, entry.context.description)
							.. lst.get_docstring(luasnip, entry.ft, entry.context)[1]
					end,
				},
				import = {
					insert_at_top = true,
					custom_languages = {
						{
							regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
							filetypes = { "typescript", "typescriptreact", "javascript", "react" },
							extensions = { "js", "ts" },
						},
					},
				},
			},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("noice")
		telescope.load_extension("luasnip")
	end,
	keys = {
		{
			"<leader>ff",
			"<cmd>Telescope find_files hidden=true no_ignore=true no_ignore_parent=true follow=true<CR>",
			desc = "Telescope Find Files",
			silent = true,
			noremap = true,
		},
		{
			"<leader>ft",
			"<cmd>Telescope live_grep<CR>",
			desc = "Telescope Live Grep",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fb",
			"<cmd>Telescope buffers<CR>",
			desc = "Telescope Buffers",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fx",
			"<cmd>Telescope help_tags<CR>",
			desc = "Telescope Help Tags",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fp",
			function()
				require("telescope.builtin").oldfiles({
					cwd_only = true,
					tiebreak = function(current_entry, existing_entry, _)
						return current_entry.index < existing_entry.index
					end,
				})
			end,
			"<cmd>Telescope oldfiles<CR>",
			desc = "Telescope Recent Files",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fa",
			"<cmd>Telescope autocommands<CR>",
			desc = "Telescope Autocommands",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fc",
			"<cmd>Telescope commands<CR>",
			desc = "Telescope Commands",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fk",
			"<cmd>Telescope keymaps<CR>",
			desc = "Telescope Keymaps",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fF",
			"<cmd>Telescope filetypes<CR>",
			desc = "Telescope Filetypes",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fo",
			"<cmd>Telescope vim_options<CR>",
			desc = "Telescope Vim Options",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fH",
			"<cmd>Telescope highlights<CR>",
			desc = "Telescope Highlights",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fB",
			"<cmd>Telescope current_buffer_fuzzy_find<CR>",
			desc = "Telescope Current Buffer Fuzzy Find",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fC",
			"<cmd>Telescope command_history<CR>",
			desc = "Telescope Command History",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fM",
			"<cmd>Telescope marks<CR>",
			desc = "Telescope Marks",
			silent = true,
			noremap = true,
		},
		{
			"<leader>gs",
			"<cmd>Telescope git_status<CR>",
			desc = "Telescope Git Status",
			silent = true,
			noremap = true,
		},
		{
			"<leader>gc",
			"<cmd>Telescope git_commits<CR>",
			desc = "Telescope Git Commits",
			silent = true,
			noremap = true,
		},
		{
			"<leader>gb",
			"<cmd>Telescope git_branches<CR>",
			desc = "Telescope Git Branches",
			silent = true,
			noremap = true,
		},
		{
			"<leader>fl",
			"<cmd>Telescope luasnip<CR>",
			desc = "Telescope LuaSnip",
			silent = true,
			noremap = true,
		},
		{
			"gr",
			"<cmd>Telescope lsp_references<CR>",
			desc = "Telescope LSP References",
			silent = true,
			noremap = true,
		},
	},
	dependencies = {
		{ "plenary.nvim", lazy = true },
		{ "benfowler/telescope-luasnip.nvim", lazy = true },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			lazy = true,
			build = "make",
		},
	},
}
