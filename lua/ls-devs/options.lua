vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set guicursor=i:blinkon1]])


local options = {
  backup = false,
  showtabline = 0,
  clipboard = "unnamedplus",
  cmdheight = 0,
  laststatus = 2,
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
  updatetime = 100,
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
  foldlevel = 99,
  foldlevelstart = 99,
  foldmethod = "manual",
  -- foldexpr = "nvim_treesitter#foldexpr()",
  foldcolumn = "1",
  foldenable = true,
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
