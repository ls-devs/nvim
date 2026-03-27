---@diagnostic disable: undefined-global
-- ── core/options ─────────────────────────────────────────────────────────
-- Purpose : Global Neovim options, keymaps, and environment-aware clipboard.
-- Trigger : Loaded at startup by core/init.lua (before plugin bootstrap)
-- ─────────────────────────────────────────────────────────────────────────

-- ── Built-in plugin disabling ─────────────────────────────────────────────
-- rplugin.vim scans the remote-plugin manifest (~3.7ms) but this config has
-- no Python / Ruby / Perl remote plugins registered.
vim.g.loaded_remote_plugins = 1

-- ── Highlight Overrides ───────────────────────────────────────────────────
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "Type", { fg = "#f9e2af" })
-- ── Cursor & Word Motion ──────────────────────────────────────────────────
vim.opt.whichwrap:append("<,>,[,],h,l") -- allow h/l and arrow keys to cross line boundaries
vim.opt.iskeyword:append("-") -- treat hyphenated-words as a single keyword token
-- block cursor in normal/visual/command; thin bar in insert; horizontal bar in replace
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

-- ── Leader Keys ───────────────────────────────────────────────────────────
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("", "<Space>", "<Nop>", opts) -- prevent Space from moving the cursor when unused
-- ── Clipboard Detection ───────────────────────────────────────────────────
-- Three-branch detection: Docker (OSC 52), WSL (win32yank / PowerShell fallback),
-- and bare Linux (unnamedplus via the system provider, applied at the bottom of this file).
local in_docker = os.getenv("container") == "docker" or vim.fn.filereadable("/.dockerenv") == 1
local in_wsl = vim.fn.has("wsl") == 1

-- Branch 1 — Docker: no host clipboard access; emit OSC 52 escape sequences
-- directly to stdout so the terminal emulator bridges yanks to the system clipboard.
if in_docker then
	---@param lines string[]
	local function copy_osc52(lines)
		local text = table.concat(lines, "\n")
		local base64 = vim.base64.encode(text)
		local osc52 = string.format("\027]52;c;%s\027\\", base64)
		io.stdout:write(osc52)
		io.stdout:flush()
	end

	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = copy_osc52,
			["*"] = copy_osc52,
		},
		paste = {
			---@return string[]
			["+"] = function()
				return vim.split(vim.fn.getreg("+"), "\n")
			end,
			---@return string[]
			["*"] = function()
				return vim.split(vim.fn.getreg("*"), "\n")
			end,
		},
	}

	vim.notify("📋 OSC 52 clipboard activé (Docker)", vim.log.levels.INFO)
-- Branch 2 — WSL: prefer win32yank.exe for bidirectional clipboard access.
-- Falls back to PowerShell clip.exe / Get-Clipboard when win32yank is not found.
elseif in_wsl then
	local win32yank_paths = {
		"/usr/local/bin/win32yank",
		"/usr/local/bin/win32yank.exe",
		vim.fn.expand("$HOME/.local/bin/win32yank.exe"),
		"/mnt/c/tools/win32yank.exe",
	}

	local win32yank_path = nil
	for _, path in ipairs(win32yank_paths) do
		if vim.fn.executable(path) == 1 then
			win32yank_path = path
			break
		end
	end

	if win32yank_path then
		vim.g.clipboard = {
			name = "win32yank",
			copy = {
				["+"] = { win32yank_path, "-i", "--crlf" },
				["*"] = { win32yank_path, "-i", "--crlf" },
			},
			paste = {
				["+"] = { win32yank_path, "-o", "--lf" },
				["*"] = { win32yank_path, "-o", "--lf" },
			},
			cache_enabled = false,
		}
	else
		vim.g.clipboard = {
			name = "WslClipboard",
			copy = {
				["+"] = { "/mnt/c/Windows/System32/clip.exe" },
				["*"] = { "/mnt/c/Windows/System32/clip.exe" },
			},
			paste = {
				["+"] = {
					"/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
					"-NoLogo",
					"-NoProfile",
					"-c",
					'[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				},
				["*"] = {
					"/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
					"-NoLogo",
					"-NoProfile",
					"-c",
					'[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				},
			},
			cache_enabled = false,
		}
	end
end

-- ── Vim Options ───────────────────────────────────────────────────────────
---@type table<string, any>
local options = {
	background = "dark",
	incsearch = true,
	inccommand = "split", -- live preview of :s/foo/bar replacements + affected lines in a split
	updatetime = 300, -- ms before CursorHold fires (LSP hover, gitsigns); default is 4000
	timeoutlen = 500, -- ms to wait for a mapped key sequence
	ttimeoutlen = 10, -- near-instant key-code timeout for fast <Esc> recognition
	backup = false,
	showtabline = 2, -- always show the tabline (required by tabby.nvim)
	cmdheight = 0, -- hide the command line when idle; noice.nvim floats messages instead
	wildmenu = true,
	wildmode = "longest:full,full", -- tab → complete to longest match; second tab → open full wildmenu
	laststatus = 3, -- global statusline: single bar shared across all splits (Neovim 0.7+)
	completeopt = { "menuone", "popup", "noinsert" }, -- blink.cmp: menu for single match, extra-info popup, no auto-insert
	conceallevel = 2, -- replace concealed text with its defined char (needed by markview / render-markdown)
	colorcolumn = "", -- no visual column-limit ruler
	concealcursor = "nc", -- apply concealment in normal and command modes, but not in insert
	linebreak = true,
	breakindent = true,
	breakindentopt = { "shift:2", "sbr" }, -- indent wrapped lines by 2 extra spaces; "sbr" prefixes them with showbreak
	showbreak = "↪ ", -- prefix drawn at the start of each continuation line when linebreak wraps
	fileencoding = "utf-8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10, -- cap completion popup at 10 visible items
	showmode = false, -- lualine renders the mode; built-in mode indicator is redundant
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	splitkeep = "cursor", -- keep cursor at same screen line when opening/closing splits (Neovim 0.9+)
	equalalways = false, -- don't auto-equalize window sizes on split/close (codediff manages its own layout)
	swapfile = false,
	termguicolors = true,
	undofile = true,
	writebackup = false,
	autoread = true, -- auto-reload files changed outside Neovim; pair with BufEnter checktime autocmd
	confirm = true, -- prompt instead of aborting on unsaved changes
	grepprg = "rg --vimgrep", -- use ripgrep for :grep / :lgrep
	grepformat = "%f:%l:%c:%m", -- format string matching rg --vimgrep output
	expandtab = true,
	shiftwidth = 2,
	shiftround = true, -- round indentation to nearest shiftwidth multiple
	tabstop = 2,
	cursorline = true,
	number = true,
	signcolumn = "yes:1", -- always reserve 1 column for signs (prevents layout shift on diagnostics)
	scrolloff = 8, -- keep 8 lines of context above/below the cursor
	sidescrolloff = 12, -- keep 12 columns of context when scrolling horizontally
	winblend = 0, -- no pseudo-transparency for floating windows
	pumblend = 0, -- no pseudo-transparency for the popup menu
	startofline = true, -- jump commands (G, gg, <C-d>, …) land on the first non-blank char
	jumpoptions = "view", -- preserve viewport in jump list so <C-i>/<C-o> restores exact scroll (Neovim 0.10+)
	wrap = false,
	foldcolumn = "1", -- 1-char column used by nvim-ufo to render fold open/close icons
	foldenable = true,
	foldlevelstart = 99, -- start every buffer with all folds open
	foldlevel = 99, -- keep all folds open; nvim-ufo manages the actual fold state
	foldmethod = "manual", -- nvim-ufo overrides fold computation; manual avoids conflicts with its extmarks
	-- custom fold markers and box-drawing characters for window borders
	fillchars = {
		eob = " ",
		foldsep = " ",
		fold = " ",
		foldopen = "▼",
		foldclose = "▶",
		horiz = "━",
		horizup = "┻",
		horizdown = "┳",
		vert = "┃",
		vertleft = "┫",
		vertright = "┣",
		verthoriz = "╋",
	},
	-- "terminal" is intentionally excluded to prevent snacks.terminal windows from being restored
	sessionoptions = "buffers,curdir,help,resize,folds,tabpages,winpos,winsize",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Branch 3 (default) — bare Linux: sync all yank/paste with the system clipboard.
-- Also applied globally so vim.g.clipboard providers (set above) are used for + and * registers.
vim.opt.clipboard = "unnamedplus"

-- Options requiring :append() (modifying existing option sets rather than replacing them)
vim.opt.diffopt:append("linematch:60") -- align similar lines across hunks in diffs (Neovim 0.9+)
vim.opt.shortmess:append("WIcC") -- suppress: W=written, I=intro splash, c=completion counts, C=scanning
