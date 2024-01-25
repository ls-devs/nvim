local M = {}

M.config = function()
  local comment = require("mini.comment")

  comment.setup({
    options = {
      custom_commentstring = function()
        return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
      end,
    },
  })
end

M.keys = {
  {
    "gc",
    mode = { "n", "v" },
  },
}

return M
