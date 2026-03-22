-- Cache compiled Lua bytecode across startups — reduces parse overhead on every .lua module
vim.loader.enable()

require("ls-devs.core")
