return {
  "nvim-zh/colorful-winsep.nvim",
  event = { "WinNew" },
  config = function()
    local c = require("tokyonight.colors").setup()
    require("colorful-winsep").setup({
      highlight = {
        fg = c.orange,
      },
      interval = 30,
      no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
      symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
      close_event = function() end,
      create_event = function()
        local win_n = require("colorful-winsep.utils").calculate_number_windows()
        if win_n == 2 then
          local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
          local filetype =
              vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(win_id) })
          if filetype == "NvimTree" then
            require("colorful_winsep").NvimSeparatorDel()
          end
        end
      end,
    })
  end,
}
