---@diagnostic disable: undefined-global
-- ── core/keymaps ─────────────────────────────────────────────────────────
-- Purpose : All global keymaps defined with native vim.keymap.set.
--           Previously managed by legendary.nvim.
-- Trigger : Loaded at startup by core/init.lua
-- Note    : Keymaps are browsable via <leader>fk (KeymapsList in custom_functions.lua)
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

-- ── GitHub Auth ───────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>ga", function()
	require("ls-devs.utils.custom_functions").GhSwitch()
end, { noremap = true, silent = true, desc = "GitHub Auth Switch" })

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

vim.keymap.set("n", "<leader>cl", function()
	if vim.bo.filetype == "snacks_dashboard" then
		local cc_cfg = require("codecompanion.config")
		local orig_layout = cc_cfg.display.cli.window.layout
		local orig_width = cc_cfg.display.cli.window.width
		local orig_height = cc_cfg.display.cli.window.height
		cc_cfg.display.cli.window.layout = "float"
		cc_cfg.display.cli.window.width = 0.85
		cc_cfg.display.cli.window.height = 0.7
		require("codecompanion").toggle_cli()
		cc_cfg.display.cli.window.layout = orig_layout
		cc_cfg.display.cli.window.width = orig_width
		cc_cfg.display.cli.window.height = orig_height
	else
		require("codecompanion").toggle_cli()
	end
end, { noremap = true, silent = true, desc = "Toggle CodeCompanion CLI" })

vim.keymap.set({ "n", "v" }, "<leader>ca", function()
	vim.cmd("CodeCompanionCLI Ask")
end, { noremap = true, silent = true, desc = "CodeCompanion CLI Ask" })
