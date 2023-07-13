local M = {}

M.config = function()
  require("NeoComposer").setup({
    notify = true,
    delay_timer = 150,
    colors = {
      bg = "#16161e",
      fg = "#ff9e64",
      red = "#ec5f67",
      blue = "#5fb3b3",
      green = "#99c794",
    },
    keymaps = {
      play_macro = "<leader>@",
      yank_macro = "<leader>yq",
      stop_macro = "<leader>sq",
      toggle_record = "<leader>q",
      cycle_next = "<leader>qn",
      cycle_prev = "<leader>qp",
      toggle_macro_menu = "<leader>qm",
    },
  })
end

M.keys = {
  {
    "<leader>@",
    function()
      require("NeoComposer").play_macro()
    end,
    desc = "NeoComposer Play Macro",
  },
  {
    "<leader>yq",
    function()
      require("NeoComposer").yank_macro()
    end,
    desc = "NeoComposer Yank Macro",
  },
  {
    "<leader>sq",
    function()
      require("NeoComposer").stop_macro()
    end,
    desc = "NeoComposer Stop Macro",
  },
  {
    "<leader>q",
    function()
      require("NeoComposer").toggle_record()
    end,
    desc = "NeoComposer Record Macro",
  },
  {
    "<leader>qn",
    function()
      require("NeoComposer").cycle_next()
    end,
    desc = "NeoComposer Cycle Next",
  },
  {
    "<leader>qp",
    function()
      require("NeoComposer").cycle_prev()
    end,
    desc = "NeoComposer Cycle Prev",
  },

  {
    "<Leader>qm",
    "<cmd>lua require('NeoComposer').toggle_macro_menu()<CR>",
    desc = "NeoComposer Toggle Menu",
  },
}

return M
