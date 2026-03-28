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

-- In markdown/codecompanion buffers: drop conceallevel to 0 when entering
-- visual mode so raw syntax (**, `, [], etc.) is visible for selection.
-- Restore to 2 when leaving visual mode.
vim.api.nvim_create_autocmd("ModeChanged", {
	group = augroup,
	pattern = { "*:[vV\x16]*", "[vV\x16]*:*" },
	callback = function()
		local ft = vim.bo.filetype
		if ft ~= "markdown" and ft ~= "codecompanion" then
			return
		end
		local in_visual = vim.fn.mode():match("^[vV\x16]") ~= nil
		vim.wo.conceallevel = in_visual and 0 or 2
	end,
	desc = "Markdown: show raw syntax in visual mode",
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "codecompanion_cli",
	callback = function(args)
		-- <C-q> hides the CLI panel from terminal mode without killing the process
		vim.keymap.set("t", "<C-q>", function()
			require("codecompanion").toggle_cli()
		end, { buffer = args.buf, silent = true, desc = "Hide CodeCompanion CLI" })
	end,
	desc = "CodeCompanion CLI buffer-local keymaps",
})

-- Fix: upstream cli/input.lua skips both focus and submit when bang=true.
-- Our handler focuses the CLI and explicitly sends \r via chansend (bypassing
-- the flaky consumer timer) so :w! both submits and lands you in the CLI.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "codecompanion_input",
	callback = function(args)
		vim.api.nvim_create_autocmd("BufWriteCmd", {
			group = augroup,
			buffer = args.buf,
			callback = function()
				if vim.v.cmdbang == 1 then
					vim.schedule(function()
						local cli_module = require("codecompanion.interactions.cli")
						local instance = cli_module.last_cli()
						if not instance then
							return
						end
						instance:focus()
						-- Poll until the terminal provider is ready (handles both the
						-- "already open" case and the "just started" case where the pty
						-- needs up to ~500ms to stabilise before it can accept input).
						local attempts = 0
						local function try_submit()
							attempts = attempts + 1
							if attempts > 40 then
								return
							end
							local provider = instance.provider
							if provider and provider.ready and provider.chan then
								vim.fn.chansend(provider.chan, "\r")
							else
								vim.defer_fn(try_submit, 100)
							end
						end
						try_submit()
					end)
				end
			end,
			desc = "Focus + submit CLI after :w!",
		})
	end,
	desc = "CodeCompanion ask input :w! focus fix",
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

-- Restore cursor to the last-visited position when a buffer is first read.
-- BufReadPost fires once when file content is loaded from disk, so it won't
-- jump the cursor every time the window is entered or a buffer is switched.
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function(ev)
		-- Skip special/non-file buffers where restoring makes no sense
		local bt = vim.bo[ev.buf].buftype
		if bt ~= "" then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(ev.buf)
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

-- Remove auto-inserted comment leaders (c/r/o from formatoptions).
-- Many filetype plugins re-add c/r/o after FileType fires; using a late priority
-- ensures this runs after them and wins.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Remove auto-comment-leader formatoptions (c/r/o)",
})

-- Trigger checktime so autoread reloads files changed outside Neovim.
-- Guarded by vim_did_enter so it never fires during the startup sequence,
-- and by getcmdwintype() to skip when the command-line window is open.
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	group = augroup,
	pattern = "*",
	callback = function()
		if vim.v.vim_did_enter == 1 and vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
	desc = "Checktime on BufEnter/FocusGained (pairs with autoread=true)",
})

-- Close quickfix and location-list windows with q
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "qf",
	callback = function(args)
		vim.keymap.set("n", "q", function()
			vim.cmd("cclose")
			pcall(vim.cmd, "lclose")
		end, { buffer = args.buf, silent = true, desc = "Close quickfix/loclist" })
	end,
	desc = "Close quickfix window with q",
})

-- Auto-create parent directories when saving a new file whose path doesn't exist yet
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function(args)
		-- Skip remote/special buffers (e.g. fugitive://, oil://)
		if args.match:match("^%w+://") then
			return
		end
		local dir = vim.fn.fnamemodify(args.match, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
	desc = "Auto-create parent directories on save",
})
