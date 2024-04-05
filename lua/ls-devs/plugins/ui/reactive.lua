return {
	"rasulomaroff/reactive.nvim",
	event = "VeryLazy",
	init = function()
		-- Quickfix for this issue https://github.com/nvim-telescope/telescope.nvim/issues/2501
		vim.api.nvim_create_augroup("my_telescope", { clear = true })
		vim.api.nvim_create_autocmd({ "WinLeave" }, {
			group = "my_telescope",
			pattern = "*",
			callback = function()
				if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
				end
			end,
		})
	end,
	opts = {
		load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
	},
}
