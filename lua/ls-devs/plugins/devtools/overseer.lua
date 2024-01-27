-- Fix Overseer with Windows
local isOpen = false
function OverseerToggle()
  if not isOpen then
    vim.cmd(":OverseerToggle")
    if vim.fn.exists(":WindowsDisableAutowidth") > 0 then
      vim.cmd(":WindowsDisableAutowidth")
    end
    isOpen = true
  else
    vim.cmd(":OverseerToggle")
    if vim.fn.exists(":WindowsEnableAutowidth") > 0 then
      vim.cmd(":WindowsEnableAutowidth")
    end
    isOpen = false
  end
end

return {
  "stevearc/overseer.nvim",
  config = function()
    require("overseer").setup({
      form = {
        win_opts = {
          winblend = 0,
        },
      },
      confirm = {
        win_opts = {
          winblend = 0,
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
      task_list = {
        bindings = {
          ["?"] = "ShowHelp",
          ["g?"] = "ShowHelp",
          ["<CR>"] = "RunAction",
          ["<C-e>"] = "Edit",
          ["o"] = "Open",
          ["<C-v>"] = "OpenVsplit",
          ["<C-s>"] = "OpenSplit",
          ["<C-f>"] = "OpenFloat",
          ["<C-q>"] = "OpenQuickFix",
          ["p"] = "TogglePreview",
          ["<C-o>"] = "IncreaseDetail",
          ["<C-c>"] = "DecreaseDetail",
          ["L"] = "IncreaseAllDetail",
          ["H"] = "DecreaseAllDetail",
          ["["] = "DecreaseWidth",
          ["]"] = "IncreaseWidth",
          ["{"] = "PrevTask",
          ["}"] = "NextTask",
          ["<C-k>"] = "ScrollOutputUp",
          ["<C-j>"] = "ScrollOutputDown",
        },
      },
    })
  end,
  keys = {
    { "<leader>or", "<cmd>OverseerRun<CR>",          desc = "Overseer Run" },
    { "<leader>ot", "<cmd>lua OverseerToggle()<CR>", desc = "Overseer Toggle" },
  },
  dependencies = {
    {
      "akinsho/toggleterm.nvim",
      opts = function()
        local colors = require("tokyonight.colors").setup()
        local toggleterm = require("toggleterm")

        toggleterm.setup({
          size = 9,
          open_mapping = [[<c-\>]],
          hide_numbers = true,
          auto_scroll = false,
          shade_filetypes = {},
          shade_terminals = false,
          shading_factor = 2,
          start_in_insert = true,
          insert_mappings = true,
          persist_size = true,
          direction = "float",
          quit_on_exit = true,
          close_on_exit = true,
          shell = vim.o.shell,
          highlights = {
            border = "Normal",
            background = "Normal",
            Normal = {
              guibg = colors.none,
            },
            FloatBorder = {
              guifg = colors.blue,
              guibg = colors.none,
            },
          },
          float_opts = {
            border = "rounded",
            winblend = 0,
            width = 100,
            height = 25,
            title_pos = "left",
          },
        })

        function _G.set_terminal_keymaps()
          local opts = { noremap = true }
          vim.api.nvim_buf_set_keymap(0, "t", "<C-x>", [[<Cmd>q!<CR>]], opts)
          vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
          vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
          vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
          vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
          vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
      end,
      keys = {
        {
          "<leader>z",
          "<cmd>ToggleTerm<CR>",
          desc = "ToggleTerm",
        },
      },
    },
  },
}
