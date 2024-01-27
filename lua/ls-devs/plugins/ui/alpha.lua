return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    vim.api.nvim_exec2(
      [[autocmd FileType alpha set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3]],
      { output = false }
    )
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
      dashboard.button("e", "󰙅 " .. " NeoTree", "<cmd>Neotree float<CR>"),
      dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files <CR>"),
      dashboard.button("t", " " .. " Find text", "<cmd>Telescope live_grep <CR>"),
      dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles <CR>"),
      dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("l", " " .. " Lazy", "<cmd>Lazy<CR>"),
      dashboard.button("m", "󱧕 " .. " Mason", "<cmd>Mason<CR>"),
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
        dashboard.section.footer.val = "⚡ Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
