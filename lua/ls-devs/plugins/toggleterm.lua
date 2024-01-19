local M = {}
M.config = function()
  local colors = require("tokyonight.colors").setup()
  local toggleterm = require("toggleterm")

  toggleterm.setup({
    size = 9,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    auto_scroll = true,
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2,
    start_in_insert = false,
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
      width = 95,
      height = 25,
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
end

M.keys = {
  { "<C-y>", ":ToggleTerm<CR>", desc = "ToggleTerm" },
}

return M
