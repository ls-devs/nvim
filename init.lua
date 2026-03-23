-- Cache compiled Lua bytecode across startups — reduces parse overhead on every .lua module
vim.loader.enable(true)

require("ls-devs.core")
