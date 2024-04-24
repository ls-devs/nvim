return {
	"akinsho/toggleterm.nvim",
	opts = {
		size = 9,
		open_mapping = [[<c-\>]],
		hide_numbers = true,
		auto_scroll = false,
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		direction = "float",
		quit_on_exit = true,
		close_on_exit = true,
		shell = vim.o.shell,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
		float_opts = {
			border = "rounded",
			winblend = 0,
			width = 100,
			height = 25,
			title_pos = "left",
		},
	},
	config = function(_, opts)
		local colors = require("catppuccin.palettes.mocha")
		require("toggleterm").setup(vim.tbl_deep_extend("force", opts, {
			highlights = {
				Normal = {
					guibg = colors.none,
				},
				FloatBorder = {
					guifg = colors.blue,
					guibg = colors.none,
				},
			},
		}))
	end,
	init = function()
		function _G.set_terminal_keymaps()
			local options = { noremap = true, silent = true }
			vim.api.nvim_buf_set_keymap(0, "t", "<C-x>", [[<Cmd>q!<CR>]], options)
			vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], options)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], options)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], options)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], options)
			vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], options)
		end
		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
	keys = {
		{
			"<leader>z",
			"<cmd>ToggleTerm<CR>",
			desc = "ToggleTerm",
			noremap = true,
			silent = true,
		},
	},
}
