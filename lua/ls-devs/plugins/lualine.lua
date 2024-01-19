local M = {}

M.config = function()
  local lualine = require("lualine")
  local c = require("tokyonight.colors").setup()

  local colors = {
    bg = c.black,
    fg = c.dark5,
    yellow = c.yellow,
    cyan = c.cyan,
    darkblue = c.blue0,
    green = c.hint,
    orange = c.orange,
    violet = c.purple,
    magenta = c.magenta,
    blue = c.blue,
    red = c.red,
  }

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand("%:p:h")
      local gitdir = vim.fn.finddir(".git", filepath .. ";")
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  -- Config
  local config = {
    extensions = {
      "lazy",
      "neo-tree",
      "nvim-dap-ui",
      "trouble",
      "overseer",
      "quickfix",
      "aerial",
      "man",
    },
    options = {
      -- Disable sections and component separators
      component_separators = "",
      section_separators = "",
      theme = {
        normal = { c = { fg = colors.fg, bg = nil } },
        inactive = { c = { fg = colors.fg, bg = colors.bg } },
      },
      disabled_filetypes = { "NvimTree", "alpha" },
    },
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left({
    function()
      return " "
    end,
    color = function()
      local mode_color = {
        n = colors.red,
        i = colors.green,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  })
  ins_left({
    "filesize",
    cond = conditions.buffer_not_empty,
  })

  ins_left({ "location", color = { fg = colors.white, gui = "bold" } })

  ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })
  ins_left({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    diagnostics_color = {
      error = { fg = colors.red, gui = "bold" },
      warn = { fg = colors.yellow, gui = "bold" },
      info = { fg = colors.white, gui = "bold" },
      hint = { fg = colors.cyan, gui = "bold" },
    },
    colored = true,
  })
  ins_left({
    function()
      return os.date("%H:%M:%S", os.time())
    end,
    color = {
      fg = colors.blue,
      gui = "bold",
    },
  })
  ins_left({
    function()
      return require("lazy.status").updates()
    end,
    cond = require("lazy.status").has_updates,
    color = { fg = colors.orange },
  })
  ins_left({
    "filename",
    fmt = function(str)
      if vim.bo.filetype ~= "toggleterm" then
        if string.len(str) > 35 then
          local fileExt = string.match(str, "[^.]+$")
          return string.sub(str, 0, 35 - string.len(fileExt)) .. "..." .. fileExt
        else
          return str
        end
      else
        local pID = string.gsub(str, "%d+:", "")
        return string.gsub(pID, ";#toggleterm#%d+", "")
      end
    end,
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = "bold" },
  })
  ins_right({
    function()
      return require("NeoComposer.ui").status_recording()
    end,
  })
  ins_right({
    function()
      local cur_buf = vim.api.nvim_get_current_buf()
      return require("hbac.state").is_pinned(cur_buf) and "" or ""
      -- tip: nerd fonts have pinned/unpinned icons!
    end,
    color = { fg = "#ef5f6b", gui = "bold" },
  })

  ins_right({
    -- Lsp server name .
    function()
      local msg = "No Active Lsp"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end,
    icon = " LSP :",
    color = { fg = "#ffffff", gui = "bold" },
  })

  ins_right({
    "o:encoding",
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = "bold" },
  })

  ins_right({
    "fileformat",
    fmt = string.upper,
    icons_enabled = false,
    color = { fg = colors.green, gui = "bold" },
  })

  ins_right({
    fmt = function(str)
      if string.len(str) >= 30 then
        return string.sub(str, 0, 27) .. "..."
      else
        return str
      end
    end,
    "branch",
    icon = "",
    color = { fg = colors.violet, gui = "bold" },
  })

  ins_right({
    "diff",
    symbols = { added = " ", modified = " ", removed = "󰛌 " },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.orange },
      removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  })

  lualine.setup(config)
  lualine.setup(config)
  lualine.setup(config)
end

return M
