local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: undefined-field
require("lazy").setup({
  spec = {
    { import = "ls-devs.plugins" },
    { import = "ls-devs.plugins.completion" },
    { import = "ls-devs.plugins.devtools" },
    { import = "ls-devs.plugins.git" },
    { import = "ls-devs.plugins.keymap" },
    { import = "ls-devs.plugins.lsp" },
    { import = "ls-devs.plugins.movement" },
    { import = "ls-devs.plugins.preview" },
    { import = "ls-devs.plugins.system" },
    { import = "ls-devs.plugins.ui" },
    { import = "ls-devs.plugins.utils" },
  },
  defaults = {
    lazy = true,
    -- version = "*",
  },
  ui = {
    border = "rounded",
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "󰄳 ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = true,
  },
  readme = {
    enabled = true,
  },
})
