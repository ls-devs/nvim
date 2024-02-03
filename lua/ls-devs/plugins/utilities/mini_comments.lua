return {
  "echasnovski/mini.comment",
  config = function()
    local comment = require("mini.comment")
    comment.setup({
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    })
  end,
  keys = {
    {
      "gc",
      mode = { "n", "v" },
      desc = "Comment",
      silent = true,
      noremap = true,
    },
  },
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = {
        enable_autocmd = false,
      },
    },
  },
}
