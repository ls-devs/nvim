return {
  "echasnovski/mini.indentscope",
  event = "BufReadPost",
  opts = {
    symbol = "│",
    options = { try_as_border = true },
    -- TODO: Move to legendary
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    }),
  },
}
