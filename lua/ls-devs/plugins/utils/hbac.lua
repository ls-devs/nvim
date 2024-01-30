return {
  "axkirillov/hbac.nvim",
  event = "BufReadPost",
  config = function()
    local actions = require("hbac.telescope.actions")
    require("hbac").setup({
      autoclose = true, -- set autoclose to false if you want to close manually
      threshold = 10, -- hbac will start closing unedited buffers once that number is reached
      close_command = function(bufnr)
        vim.api.nvim_buf_delete(bufnr, {})
      end,
      close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
      telescope = {
        mappings = {
          n = {
            ["<C-c>"] = actions.close_unpinned,
            ["<C-x>"] = actions.delete_buffer,
            ["<C-a>"] = actions.pin_all,
            ["<C-u>"] = actions.unpin_all,
            ["<C-y>"] = actions.toggle_pin,
          },
          i = {
            ["<C-c>"] = actions.close_unpinned,
            ["<C-x>"] = actions.delete_buffer,
            ["<C-a>"] = actions.pin_all,
            ["<C-u>"] = actions.unpin_all,
            ["<C-y>"] = actions.toggle_pin,
          },
        },
        -- Pinned/unpinned icons and their hl groups. Defaults to nerdfont icons
        pin_icons = {
          pinned = { "󰐃 ", hl = "DiagnosticOk" },
          unpinned = { "󰤱 ", hl = "DiagnosticError" },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>fh",
      "<cmd>Hbac telescope<CR>",
      desc = "Hbac Telescope",
      silent = true,
      noremap = true,
    },
    {
      "<leader>ht",
      "<cmd>Hbac toggle_pin<CR>",
      desc = "HBac Toggle Pin",
      silent = true,
      noremap = true,
    },
    {
      "<leader>hu",
      "<cmd>Hbac unpin_all<CR>",
      desc = "HBac Unpin All",
      silent = true,
      noremap = true,
    },
    {
      "<leader>hp",
      "<cmd>Hbac pin_all<CR>",
      desc = "HBac Pin All",
      silent = true,
      noremap = true,
    },
    {
      "<leader>hc",
      "<cmd>Hbac close_unpinned<CR>",
      desc = "HBac Close Unpinned",
      silent = true,
      noremap = true,
    },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}
