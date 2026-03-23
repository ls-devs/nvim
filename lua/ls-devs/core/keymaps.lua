---@diagnostic disable: undefined-global
-- ── core/keymaps ─────────────────────────────────────────────────────────
-- Purpose : All global keymaps defined with native vim.keymap.set.
--           Previously managed by legendary.nvim.
-- Trigger : Loaded at startup by core/init.lua
-- Note    : Keymaps are browsable via <leader>fk (Snacks.picker.keymaps)
-- ─────────────────────────────────────────────────────────────────────────

---@type { noremap: boolean, silent: boolean }
local opts = { noremap = true, silent = true }

-- ── Fold-aware h / l (nvim-origami logic) ────────────────────────────────
vim.keymap.set("n", "h", function()
	local h, _ = require("ls-devs.utils.custom_functions").OrigamiHLFolds()
	h()
end, { noremap = true, silent = true, desc = "Origami h (close fold / move left)" })

vim.keymap.set("n", "l", function()
	local _, l = require("ls-devs.utils.custom_functions").OrigamiHLFolds()
	l()
end, { noremap = true, silent = true, desc = "Origami l (open fold / move right)" })

-- ── Navigation ────────────────────────────────────────────────────────────
-- <C-d>/<C-u>/G/gg intentionally have NO zz — snacks.scroll already animates
-- the full jump; adding zz would trigger a second back-to-back animation.
vim.keymap.set("n", "<C-d>", "<C-d>", { noremap = true, silent = true, desc = "Navigate Down" })
vim.keymap.set("n", "<C-u>", "<C-u>", { noremap = true, silent = true, desc = "Navigate Up" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", opts)
vim.keymap.set("n", "<C-o>", "<C-o>zz", opts)
vim.keymap.set("n", "{", "{zz", opts)
vim.keymap.set("n", "}", "}zz", opts)
vim.keymap.set("n", "N", "Nzz", opts)
vim.keymap.set("n", "n", "nzz", opts)
vim.keymap.set("n", "G", "G", opts)
vim.keymap.set("n", "gg", "gg", opts)
vim.keymap.set("n", "%", "%zz", opts)
vim.keymap.set("n", "*", "*zz", opts)
vim.keymap.set("n", "#", "#zz", { noremap = true, silent = true, desc = "Navigate Up & Center" })

-- ── Visual / select mode ──────────────────────────────────────────────────
-- <A-j>/<A-k>: move lines; visual mode uses in-place reindent, x-mode keeps selection.
vim.keymap.set("v", "<A-j>", "<cmd>m .+1<CR>==", { noremap = true, silent = true, desc = "Move Line Down" })
vim.keymap.set("x", "<A-j>", "<cmd>move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move Line Down" })
vim.keymap.set("v", "<A-k>", "<cmd>m .-2<CR>==", { noremap = true, silent = true, desc = "Move Line Up" })
vim.keymap.set("x", "<A-k>", "<cmd>move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move Line Up" })
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true, desc = "Paste without clobbering register" })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- ── Search ────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>nh", function()
	vim.cmd.noh()
end, { desc = "Remove Search Highlight" })

vim.keymap.set("n", "<leader>hg", function()
	require("ls-devs.utils.custom_functions").HelpGrep()
end, { noremap = true, silent = true, desc = "Help Grep" })

-- ── Folding (nvim-ufo) ────────────────────────────────────────────────────
vim.keymap.set("n", "zR", function()
	require("ufo").openAllFolds()
end, { noremap = true, silent = true, desc = "UFO Open All Folds" })

vim.keymap.set("n", "zM", function()
	require("ufo").closeAllFolds()
end, { noremap = true, silent = true, desc = "UFO Close All Folds" })

-- ── LSP ───────────────────────────────────────────────────────────────────
vim.keymap.set({ "i", "n" }, "<C-s>", function()
	vim.lsp.buf.signature_help()
	require("blink.cmp").hide()
end, { noremap = true, silent = true, desc = "LSP Signature Help" })

-- ── Noice ─────────────────────────────────────────────────────────────────
-- <C-f>/<C-b>: scroll floating doc windows; fall back to native mapping when
-- no Noice window is active (expr = true).
vim.keymap.set(
	{ "n", "i", "s" },
	"<C-f>",
	---@return string?
	function()
		if not require("noice.lsp").scroll(4) then
			return "<C-f>"
		end
	end,
	{ silent = true, expr = true, desc = "Noice Scroll Doc Forward" }
)

vim.keymap.set(
	{ "n", "i", "s" },
	"<C-b>",
	---@return string?
	function()
		if not require("noice.lsp").scroll(-4) then
			return "<C-b>"
		end
	end,
	{ silent = true, expr = true, desc = "Noice Scroll Doc Backward" }
)

vim.keymap.set("c", "<A-x>", function()
	return require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Noice Redirect Cmdline" })

-- ── Utilities ─────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<CR>", { noremap = true, silent = true, desc = "Lazy" })

vim.keymap.set("n", "<leader>lg", function()
	Snacks.lazygit()
end, { noremap = true, silent = true, desc = "LazyGit" })

-- Toggle codespell linter on/off for the current session
vim.keymap.set("n", "<leader>cs", function()
	local lint = require("lint")
	if #(lint.linters_by_ft["*"] or {}) > 0 then
		lint.linters_by_ft["*"] = {}
	else
		lint.linters_by_ft["*"] = { "codespell" }
		vim.cmd(":edit!")
	end
end, { noremap = true, silent = true, desc = "Toggle Codespell Linter" })

-- Toggle CodeCompanion CLI float (reuse existing buffer if already open)
vim.keymap.set("n", "<leader>cl", function()
	local cli_buf = nil
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].filetype == "codecompanion_cli" then
			cli_buf = buf
			break
		end
	end
	if cli_buf then
		local wins = vim.fn.win_findbuf(cli_buf)
		if #wins > 0 then
			vim.api.nvim_win_close(wins[1], false)
		else
			local columns = vim.o.columns
			local lines = vim.o.lines
			local width = math.floor(columns * 0.85)
			local height = math.floor(lines * 0.85)
			local col = math.floor((columns - width) / 2)
			local row = math.floor((lines - height) / 2)
			local win = vim.api.nvim_open_win(cli_buf, true, {
				relative = "editor",
				width = width,
				height = height,
				col = col,
				row = row,
				border = "rounded",
				title = " CodeCompanion CLI ",
				title_pos = "center",
			})
			vim.wo[win].number = false
			vim.wo[win].relativenumber = false
			vim.wo[win].wrap = true
			vim.wo[win].signcolumn = "yes:1"
			vim.wo[win].scrolloff = 1
			vim.cmd("startinsert")
		end
	else
		vim.cmd("CodeCompanionCLI")
		vim.schedule(function()
			vim.cmd("startinsert")
		end)
	end
end, { noremap = true, silent = true, desc = "Toggle CodeCompanion CLI" })
