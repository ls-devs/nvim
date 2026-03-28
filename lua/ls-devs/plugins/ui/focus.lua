-- ── focus.nvim ────────────────────────────────────────────────────────────
-- Purpose : Window resizing — manual (wm/we) or auto golden-ratio (wr toggle)
-- Trigger : BufReadPost, BufNewFile
-- Note    : autoresize.enable=true is required for both manual commands AND
--           the WinEnter autocmd. We patch the autocmd after setup to respect
--           is_disabled() — focus.nvim's own callback skips this check, which
--           causes winwidth/winheight to be reset on every window switch even
--           when "disabled", producing a subtle rebalance on Ctrl-H/L.
--           We start disabled (vim.g.focus_disable=true after setup) so the
--           autocmd is registered but silently skipped. <leader>wr toggles.
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"nvim-focus/focus.nvim",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		enable = true,
		commands = true,
		split = { bufnew = false, tmux = false },
		autoresize = { enable = true },
		ui = {
			number = false,
			relativenumber = false,
			hybridnumber = false,
			absolutenumber_unfocussed = false,
			cursorline = false,
			cursorcolumn = false,
			colorcolumn = { enable = false },
			signcolumn = false,
			winhighlight = false,
		},
	},
	config = function(_, opts)
		require("focus").setup(opts)

		-- Patch: replace the Focus augroup's WinEnter callback with one that
		-- checks is_disabled() before calling resize(). Without this, focus.nvim
		-- still runs split_resizer on every WinEnter even when toggled off,
		-- setting winwidth/winheight=1 and causing a subtle window rebalance.
		local augroup = vim.api.nvim_create_augroup("Focus", { clear = true })
		local ignore_ft = {
			"neo-tree",
			"neo-tree-popup",
			"neotest-summary",
			"Trouble",
			"trouble",
			"dap-repl",
			"dapui_console",
			"dapui_watches",
			"dapui_stacks",
			"dapui_breakpoints",
			"dapui_scopes",
			"OverseerList",
			"dbui",
			"dbout",
			"lazy",
			"mason",
			"codecompanion_cli",
			"codediff-explorer",
			"codediff-history",
			"qf",
		}
		vim.api.nvim_create_autocmd("WinEnter", {
			group = augroup,
			callback = function()
				if vim.g.focus_disable or vim.w.focus_disable or vim.b.focus_disable then
					return
				end
				-- Skip non-editing buffers and known sidebar/tool filetypes
				if vim.bo.buftype ~= "" then
					return
				end
				if vim.tbl_contains(ignore_ft, vim.bo.filetype) then
					return
				end
				require("focus").resize()
			end,
			desc = "Focus: resize focused split (guarded)",
		})

		-- Start disabled — <leader>wr (FocusToggle) opts in to auto golden-ratio
		vim.g.focus_disable = true
	end,
	keys = {
		{ "<leader>wm", "<cmd>FocusMaximise<CR>", desc = "Focus Maximise", silent = true, noremap = true },
		{ "<leader>we", "<cmd>FocusEqualise<CR>", desc = "Focus Equalise", silent = true, noremap = true },
		{ "<leader>wr", "<cmd>FocusToggle<CR>", desc = "Focus Toggle Autoresize", silent = true, noremap = true },
	},
}
