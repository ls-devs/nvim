local M = {}

M.config = function()
  local comment = require("mini.comment")

  comment.setup({
    hooks = {
      pre = function()
        require("ts_context_commentstring.internal").update_commentstring({})
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
