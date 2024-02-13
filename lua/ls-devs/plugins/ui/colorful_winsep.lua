return {
	"nvim-zh/colorful-winsep.nvim",
	event = { "BufReadPost" },
	opts = {
		interval = 30,
		no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree", "Overseer", "aerial" },
		symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
		close_event = function() end,
	},
	config = function(_, opts)
		local colors = require("catppuccin.palettes.mocha")
		require("colorful-winsep").setup(vim.tbl_deep_extend("force", opts, {
			highlight = {
				fg = colors.peach,
			},
			create_event = function()
				local win_n = require("colorful-winsep.utils").calculate_number_windows()
				if win_n == 2 then
					local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
					if win_id then
						local filetype =
							vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win_id) })
						if filetype == "NvimTree" then
							require("colorful_winsep").NvimSeparatorDel()
						end
					end
				end
			end,
		}))
	end,
}
