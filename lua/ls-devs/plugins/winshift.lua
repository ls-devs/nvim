local M = {}

M.config = function()
  require("winshift").setup({
    highlight_moving_win = false, -- Highlight the window being moved
    focused_hl_group = "Visual", -- The highlight group used for the moving window
    moving_win_options = {
      -- These are local options applied to the moving window while it's
      -- being moved. They are unset when you leave Win-Move mode.
      wrap = false,
      cursorline = false,
      cursorcolumn = false,
      colorcolumn = "",
    },
    keymaps = {
      disable_defaults = false, -- Disable the default keymaps
      win_move_mode = {
        ["h"] = "left",
        ["j"] = "down",
        ["k"] = "up",
        ["l"] = "right",
        ["H"] = "far_left",
        ["J"] = "far_down",
        ["K"] = "far_up",
        ["L"] = "far_right",
        ["<left>"] = "left",
        ["<down>"] = "down",
        ["<up>"] = "up",
        ["<right>"] = "right",
        ["<S-left>"] = "far_left",
        ["<S-down>"] = "far_down",
        ["<S-up>"] = "far_up",
        ["<S-right>"] = "far_right",
      },
    },
    ---A function that should prompt the user to select a window.
    ---
    ---The window picker is used to select a window while swapping windows with
    ---`:WinShift swap`.
    ---@return integer? winid # Either the selected window ID, or `nil` to
    ---   indicate that the user cancelled / gave an invalid selection.
    window_picker = function()
      return require("winshift.lib").pick_window({
        -- A string of chars used as identifiers by the window picker.
        picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        filter_rules = {
          -- This table allows you to indicate to the window picker that a window
          -- should be ignored if its buffer matches any of the following criteria.
          cur_win = true, -- Filter out the current window
          floats = true, -- Filter out floating windows
          filetype = {}, -- List of ignored file types
          buftype = {}, -- List of ignored buftypes
          bufname = {}, -- List of vim regex patterns matching ignored buffer names
        },
        filter_func = nil,
      })
    end,
  })
end

M.keys = {
  {
    "<leader>mh",
    function()
      vim.cmd(":WinShift left")
      vim.cmd(":WindowsEqualize")
    end,
    desc = "Move Window Left",
  },
  {
    "<leader>ml",
    function()
      vim.cmd(":WinShift right")
      vim.cmd(":WindowsEqualize")
    end,
    desc = "Move Window Right",
  },
  {
    "<leader>mk",
    function()
      vim.cmd(":WinShift up")
      vim.cmd(":WindowsEqualize")
    end,
    desc = "Move Window Up",
  },
  {
    "<leader>mj",
    function()
      vim.cmd(":WinShift down")
      vim.cmd(":WindowsEqualize")
    end,
    desc = "Move Window Down",
  },
}

return M
