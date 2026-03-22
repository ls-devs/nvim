-- ── neogit ────────────────────────────────────────────────────────────────
-- Purpose : Magit-style interactive git interface for Neovim
-- Trigger : cmd = "Neogit"
-- Note    : Integrates with diffview (diffs).
--           Popup borders are patched to rounded via User NeogitPopupShown.
-- ──────────────────────────────────────────────────────────────────────────
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
	},
	opts = {
		kind = "tab", -- open neogit in a new tab for a full-screen experience
		graph_style = "unicode", -- use Unicode box-drawing characters for the commit graph
		disable_hint = false,
		disable_context_highlighting = false,
		disable_signs = false,
		-- delegate diff views to diffview.nvim
		integrations = {
			telescope = false,
			diffview = true,
		},
		signs = {
			hunk = { "", "" },
			item = { "", "" },
			section = { "", "" },
		},
		commit_editor = {
			kind = "auto", -- pick split or tab based on available screen space
			show_staged_diff = true,
			staged_diff_split_kind = "split", -- show staged diff in a horizontal split below the editor
		},
		popup = {
			kind = "split", -- action popups (push, pull, etc.) open as horizontal splits
		},
	},
	config = function(_, opts)
		require("neogit").setup(opts)

		local neogit_border = "rounded"
		-- Disable transparency for all neogit windows (winblend=0 = fully opaque)
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
					if cfg.relative ~= "" and cfg.border then -- floating windows have a non-empty relative anchor
						vim.api.nvim_win_set_config(win, vim.tbl_extend("force", cfg, { border = neogit_border }))
					end
				end
			end,
		})
	end,
	cond = function()
		return vim.fn.isdirectory(".git") == 1 -- only load in git repositories
	end,
}
