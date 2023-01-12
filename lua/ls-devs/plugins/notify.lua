local M = {}

M.config = function()
  local stages_util = require("notify.stages.util")
  require("notify").setup({
    background_colour = "#000000",
    stages = {
      function(state)
        local next_row = stages_util.available_slot(
          state.open_windows,
          state.message.height + 2,
          stages_util.DIRECTION.BOTTOM_UP
        )

        if not next_row then
          return nil
        end

        return {
          relative = "editor",
          anchor = "NE",
          width = state.message.width,
          height = state.message.height,
          col = 1,
          row = next_row,
          border = "rounded",
          style = "minimal",
          opacity = 0,
        }
      end,
      function(state, win)
        return {
          opacity = { 100 },
          col = { 1 },
          row = {
            stages_util.slot_after_previous(win, state.open_windows, stages_util.DIRECTION.BOTTOM_UP),
            frequency = 3,
            complete = function()
              return true
            end,
          },
        }
      end,
      function(state, win)
        return {
          col = { 1 },
          time = true,
          row = {
            stages_util.slot_after_previous(win, state.open_windows, stages_util.DIRECTION.BOTTOM_UP),
            frequency = 3,
            complete = function()
              return true
            end,
          },
        }
      end,
      function(state, win)
        return {
          width = {
            1,
            frequency = 2.5,
            damping = 0.9,
            complete = function(cur_width)
              return cur_width < 3
            end,
          },
          opacity = {
            0,
            frequency = 2,
            complete = function(cur_opacity)
              return cur_opacity <= 4
            end,
          },
          col = { 1 },
          row = {
            stages_util.slot_after_previous(win, state.open_windows, stages_util.DIRECTION.BOTTOM_UP),
            frequency = 3,
            complete = function()
              return true
            end,
          },
        }
      end,
    },
  })
end

return M
