local M = {}

M.config = function()
  local animate = require("mini.animate")
  animate.setup({
    scroll = {
      subscroll = animate.gen_subscroll.equal({
        predicate = function(total_scroll)
          return total_scroll > 3
        end,
      }),
    },
  })
end

return M
