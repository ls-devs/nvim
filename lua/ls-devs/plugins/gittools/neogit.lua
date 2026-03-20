return {
	"NeogitOrg/neogit",
	cmd = "Neogit",
	keys = {
		{
			"<leader>ng",
			function()
				require("neogit").open()
			end,
			desc = "Neogit",
			noremap = true,
			silent = true,
		},
		{
			"<leader>nc",
			function()
				require("neogit").open({ kind = "split" })
			end,
			desc = "Neogit (split)",
			noremap = true,
			silent = true,
		},
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "sindrets/diffview.nvim", lazy = true },
		{ "nvim-telescope/telescope.nvim", lazy = true },
	},
	opts = {
		kind = "tab",
		graph_style = "unicode",
		disable_hint = false,
		disable_context_highlighting = false,
		disable_signs = false,
		telescope_sorter = function()
			return require("telescope").extensions.fzf.native_fzf_sorter()
		end,
		integrations = {
			telescope = true,
			diffview = true,
		},
		signs = {
			hunk = { "", "" },
			item = { "", "" },
			section = { "", "" },
		},
		commit_editor = {
			kind = "auto",
			show_staged_diff = true,
			staged_diff_split_kind = "split",
		},
		popup = {
			kind = "split",
		},
	},
	config = function(_, opts)
		require("neogit").setup(opts)

		local neogit_border = "rounded"
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "Neogit*",
			callback = function()
				vim.opt_local.winblend = 0
			end,
		})

		-- Apply rounded borders to neogit popups
		vim.api.nvim_create_autocmd("User", {
			pattern = "NeogitPopupShown",
			callback = function()
				local wins = vim.api.nvim_list_wins()
				for _, win in ipairs(wins) do
					local cfg = vim.api.nvim_win_get_config(win)
					if cfg.relative ~= "" and cfg.border then
						vim.api.nvim_win_set_config(win, vim.tbl_extend("force", cfg, { border = neogit_border }))
					end
				end
			end,
		})
	end,
	cond = function()
		return vim.fn.isdirectory(".git") == 1
	end,
}
