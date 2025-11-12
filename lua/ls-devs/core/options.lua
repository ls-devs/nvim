vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi AlphaHeader guifg=#cdd6f4")
vim.cmd("hi AlphaButtons guifg=#89b4fa")
vim.cmd("hi AlphaShortcut guifg=#fab387")
vim.cmd("hi Type guifg=#f9e2af")
vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd("set iskeyword+=-")
vim.cmd("set guicursor=n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor")

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("", "<Space>", "<Nop>", opts)
local in_docker = os.getenv("container") == "docker" or vim.fn.filereadable("/.dockerenv") == 1
local in_wsl = vim.fn.has("wsl") == 1

if in_docker then
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
			["+"] = function()
				return vim.split(vim.fn.getreg("+"), "\n")
			end,
			["*"] = function()
				return vim.split(vim.fn.getreg("*"), "\n")
			end,
		},
	}

	vim.notify("📋 OSC 52 clipboard activé (Docker)", vim.log.levels.INFO)
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

local options = {
	background = "dark",
	incsearch = true,
	backup = false,
	showtabline = 2,
	cmdheight = 0,
	laststatus = 3,
	completeopt = { "menu", "menuone", "noselect" },
	conceallevel = 0,
	linebreak = true,
	breakindent = true,
	breakindentopt = { "shift:2", "sbr" },
	fileencoding = "utf-8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
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
	signcolumn = "yes:1",
	scrolloff = 8,
	sidescrolloff = 12,
	winblend = 0,
	pumblend = 0,
	startofline = true,
	wrap = false,
	foldcolumn = "1",
	foldenable = true,
	foldlevelstart = 99,
	foldlevel = 99,
	foldmethod = "manual",
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
	sessionoptions = "buffers,curdir,help,resize,folds,tabpages,winpos,winsize",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.clipboard = "unnamedplus"
