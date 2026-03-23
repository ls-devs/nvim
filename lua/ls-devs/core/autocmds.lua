---@diagnostic disable: undefined-global
-- ── core/autocmds ────────────────────────────────────────────────────────
-- Purpose : All global autocommands defined with native nvim_create_autocmd.
--           Previously managed by legendary.nvim.
-- Trigger : Loaded at startup by core/init.lua
-- Note    : Autocommands are browsable via <leader>fa (Snacks.picker.autocmds)
-- ─────────────────────────────────────────────────────────────────────────

---@type integer
local augroup = vim.api.nvim_create_augroup("LsDevsAutocmds", { clear = true })

-- Dismiss Snacks notifier when entering insert mode to avoid distraction
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertChange" }, {
	group = augroup,
	pattern = "*",
	callback = function()
		Snacks.notifier.hide()
	end,
	desc = "Notify dismiss on insert",
})

-- Prettierd runs as a persistent background daemon; stop it on exit to
-- avoid orphaned processes accumulating across editing sessions.
vim.api.nvim_create_autocmd("VimLeave", {
	group = augroup,
	pattern = "*",
	command = "silent !prettierd stop",
	desc = "Stop prettierd on exit",
})

-- Register <leader>xe (wrap with emmet abbreviation) only for emmet-capable filetypes
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	pattern = { "*.jsx", "*.tsx", "*.vue", "*.html" },
	---@param args vim.api.keyset.create_autocmd.callback_args
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil or client.name ~= "emmet_language_server" then
			return
		end
		vim.keymap.set("n", "<leader>xe", function()
			require("nvim-emmet").wrap_with_abbreviation()
		end, { buffer = args.buf, desc = "Wrap with emmet abbreviation" })
	end,
	desc = "Setup nvim-emmet on LspAttach",
})

-- Disable focus.nvim autoresize for non-editing buffer types
vim.api.nvim_create_autocmd("WinEnter", {
	group = augroup,
	callback = function()
		local ignore_buftypes = { "nofile", "prompt", "popup" }
		vim.b.focus_disable = vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
	end,
	desc = "Disable focus autoresize for special BufType",
})

-- Disable focus.nvim autoresize for UI/tool filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function()
		local ignore_filetypes = {
			"neo-tree",
			"dap-repl",
			"SidebarNvim",
			"Trouble",
			"terminal",
			"dapui_console",
			"dapui_watches",
			"dapui_stacks",
			"dapui_breakpoints",
			"dapui_repl",
			"dapui_scopes",
			"OverseerList",
			"noice",
			"dbui",
			"dbout",
			"lazy",
		}
		vim.b.focus_disable = vim.tbl_contains(ignore_filetypes, vim.bo.filetype)
	end,
	desc = "Disable focus autoresize for UI FileType",
})

-- Brief highlight of yanked region
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ timeout = 60, visual = true })
	end,
	desc = "Blink on yank",
})

-- Re-equalize split sizes when the terminal itself is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.cmd("wincmd =")
	end,
	desc = "Auto-equalize splits on terminal resize",
})

-- Open help in a vertical split on the right
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "help",
	callback = function()
		vim.bo.bufhidden = "unload"
		vim.cmd.wincmd("L")
		vim.cmd.wincmd("=")
	end,
	desc = "Open help in vertical split",
})

-- UFO loses fold state when a session is restored; re-enable on SessionLoadPost
vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = "SessionLoadPost",
	callback = function()
		require("ufo").enable()
	end,
	desc = "Re-enable UFO after session restore",
})

-- Restore cursor to the last-visited position when reopening a buffer.
-- The `"` mark is set automatically by Vim on every BufLeave.
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = augroup,
	pattern = "*",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Restore cursor to last position",
})

-- Reset the terminal cursor shape on exit so it doesn't stay as a block
vim.api.nvim_create_autocmd("VimLeave", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.cmd('set guicursor= | call chansend(v:stderr, "\x1b[5 q")')
	end,
	desc = "Reset cursor shape on VimLeave",
})

-- Files on /mnt/* are WSL drvfs mounts where filetype detection,
-- Tree-sitter highlighting, and LSP don't fire reliably on BufRead.
-- Force detection and start LSP with a small defer.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "BufReadPost" }, {
	group = augroup,
	pattern = "/mnt/*",
	---@param args vim.api.keyset.create_autocmd.callback_args
	callback = function(args)
		local bufnr = args.buf
		local filepath = vim.api.nvim_buf_get_name(bufnr)
		if not filepath:match("^/mnt/") then
			return
		end
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "" then
				vim.cmd("filetype detect")
			end
		end)
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
			local ft = vim.bo[bufnr].filetype
			if ft ~= "" then
				pcall(vim.cmd, "TSBufEnable highlight")
			end
			if #vim.lsp.get_clients({ bufnr = bufnr }) == 0 then
				pcall(vim.cmd, "LspStart")
			end
		end, 150)
	end,
	desc = "Fix LSP and Tree-sitter on drvfs mounts (WSL)",
})
