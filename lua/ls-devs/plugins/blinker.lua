local M = {}

M.config = function()
  require("blinker").setup({
    -- How many blinks
    count = 2,

    -- Duration of each blink, in milliseconds
    duration = 100,

    -- Colour of the blink, if using the default highlight group
    color = "#cdd6f4",

    -- Highlight group to use, determining colour. If overidden, 'color' is
    -- ignored. Using a custom highlight group allows for finer-grained control
    -- of the highlight.
    highlight = "BlinkingLine",
  })
end

return M
