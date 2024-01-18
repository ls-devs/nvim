local M = {}

M.config = function()
  require("silicon").setup({
    font = "FiraCode Nerd Font=16",
    theme = "Dracula",
    background = "#6DBDFF",
    shadow = {
      blur_radius = 0.0,
      offset_x = 0,
      offset_y = 0,
      color = "#555",
    },
    pad_horiz = 70,
    pad_vert = 50,
    line_number = true,
    line_pad = 2,
    line_offset = 1,
    tab_width = 3,
    round_corner = true,
    window_controls = true,
    watermark = {
      text = nil,  -- add this to enable watermark on the bottom-right.
      color = "#222",
      style = "bold", -- possible values: 'bold' | 'italic' | 'bolditalic' | anything else defaults to 'regular'.
    },
  })
end

return M
