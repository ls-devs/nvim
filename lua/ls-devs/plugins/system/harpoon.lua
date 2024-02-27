return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("harpoon"):setup({
			cmd = {
				add = function(possible_value)
					local idx = vim.fn.line(".")

					local cmd = vim.api.nvim_buf_get_lines(0, idx - 1, idx, false)[1]
					if cmd == nil then
						return nil
					end

					return {
						value = cmd,
					}
				end,

				select = function(list_item, list, option)
					vim.cmd(list_item.value)
				end,
			},
			ufo = {
				select = function(list_item, list, option)
					local bufnr = vim.fn.bufnr(list_item.value)
					local set_position = false

					if bufnr == -1 then
						set_position = true
						bufnr = vim.fn.bufnr(list_item.value, true)
					end
					if not vim.api.nvim_buf_is_loaded(bufnr) then
						vim.fn.bufload(bufnr)
						vim.api.nvim_set_option_value("buflisted", true, {
							buf = bufnr,
						})
					end

					vim.api.nvim_set_current_buf(bufnr)

					if set_position then
						vim.api.nvim_win_set_cursor(0, {
							list_item.context.row or 1,
							list_item.context.col or 0,
						})
					end

					vim.cmd("UfoEnableFold") -- Custom behavior
				end,
			},
		})
	end,
	keys = {
		{
			"<leader>ha",
			function()
				require("harpoon"):list():append()
			end,
			desc = "Harpoon add to list",
			noremap = true,
			silent = true,
		},
		{
			"<leader>ht",
			function()
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
			end,
			desc = "Harpoon add to list",
			noremap = true,
			silent = true,
		},
		{
			"<leader>hf",
			function()
				require("ls-devs.utils.custom_functions").HarpoonTelescope(require("harpoon"):list())
			end,
			desc = "Harpoon Telescope",
			noremap = true,
			silent = true,
		},
	},
}
