vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])

vim.opt.shortmess:append("c")

local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 1,
	laststatus = 3,
	completeopt = { "menuone", "noselect" },
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
	updatetime = 300,
	writebackup = false,
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	cursorline = true,
	number = true,
	relativenumber = true,
	numberwidth = 4,
	signcolumn = "yes",
	wrap = false,
	scrolloff = 8,
	sidescrolloff = 12,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
