local M = {}

M.config = function()
  vim.api.nvim_exec([[autocmd FileType alpha set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3]], false)
  local dashboard = require("alpha.themes.dashboard")
  local version = vim.version()
  local lazy = require("lazy")

  local logo = [[



███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]] .. "\n" .. [[                      ]] .. [[v]] .. version.major .. [[.]] .. version.minor .. [[.]] .. version.patch

  dashboard.section.header.val = vim.split(logo, "\n")
  dashboard.section.buttons.val = {
    dashboard.button("e", "פּ " .. " NeoTree", ":NeoTreeFloatToggle<CR>"),
    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
    dashboard.button("m", "憐" .. " Mason", ":Mason<CR>"),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  }
  for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
  end
  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "AlphaHeader"
  dashboard.section.buttons.opts.hl = "AlphaButtons"
  dashboard.opts.layout[1].val = 8

  vim.b.miniindentscope_disable = true

  if vim.o.filetype == "lazy" then
    vim.cmd.close()
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        lazy.show()
      end,
    })
  end

  require("alpha").setup(dashboard.opts)

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      local stats = lazy.stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
      pcall(vim.cmd.AlphaRedraw)
    end,
  })
end

return M
