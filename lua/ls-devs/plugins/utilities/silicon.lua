return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  config = function()
    local colors = require("catppuccin.palettes.mocha")
    require("nvim-silicon").setup({
      font = "FiraCode Nerd Font=44",
      theme = "Catppuccin-mocha",
      background = colors.lavender,
      background_image = nil,
      pad_horiz = 70,
      pad_vert = 50,
      no_round_corner = false,
      no_window_controls = false,
      no_line_number = false,
      line_offset = function(args)
        return args.line1
      end,
      line_pad = 0,
      tab_width = 4,
      language = function()
        return vim.bo.filetype
      end,
      shadow_blur_radius = 16,
      shadow_offset_x = 8,
      shadow_offset_y = 8,
      shadow_color = "#100808",
      gobble = true,
      output = function()
        return "/mnt/c/Users/lseigneurie/Pictures/Silicon/" ..
            os.date("!%Y-%m-%dT%H-%M-%S") .. vim.fn.expand('%:t:r') .. ".png"
      end,
      to_clipboard = false,
      command = "silicon",
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
      end,

    })
  end
}
