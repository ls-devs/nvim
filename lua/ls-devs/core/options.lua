-- Hack Catppuccin lazy loading
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi AlphaHeader guifg=#cdd6f4")
vim.cmd("hi AlphaButtons guifg=#89b4fa")
vim.cmd("hi AlphaShortcut guifg=#fab387")
vim.cmd("hi Type guifg=#f9e2af")

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd("set iskeyword+=-")
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("", "<Space>", "<Nop>", opts)

-- Disable mouse except scrolling
keymap("", "<LeftMouse>", "<nop>", opts)
keymap("", "<2-LeftMouse>", "<nop>", opts)
keymap("", "<RightMouse>", "<nop>", opts)
keymap("", "<2-RightMouse>", "<nop>", opts)

-- Options
local options = {
	background = "dark",
	backup = false,
	showtabline = 0,
	clipboard = "unnamedplus",
	cmdheight = 0,
	laststatus = 3,
	completeopt = { "menu", "menuone", "noselect" },
	conceallevel = 0,
	fileencoding = "utf-8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = true,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	termguicolors = true,
	undofile = true,
	writebackup = false,
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	cursorline = true,
	number = true,
	relativenumber = true,
	numberwidth = 2,
	signcolumn = "yes:1",
	wrap = false,
	scrolloff = 8,
	sidescrolloff = 12,
	winblend = 0,
	startofline = true,
	foldenable = true,
	foldlevelstart = 99,
	foldlevel = 99,
	foldcolumn = "1",
	foldmethod = "manual",
	fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
}

-- Keyboard WSL
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end

for k, v in pairs(options) do
	vim.opt[k] = v
end
