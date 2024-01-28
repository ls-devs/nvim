return {
  "ecthelionvi/NeoComposer.nvim",
  event = "BufReadPost",
  config = function()
    -- Disable "q" for macro
    vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })
    local colors = require("tokyonight.colors").setup()

    require("NeoComposer").setup({
      notify = false,
      delay_timer = 150,
      colors = {
        bg = colors.none,
        fg = colors.orange,
        red = colors.red,
        blue = colors.blue,
        green = colors.green,
      },
      queue_most_recent = true,
      window = {
        border = "rounded",
        winhl = {
          Normal = "Normal",
        },
      },
      keymaps = {
        play_macro = "@",
        yank_macro = "yq",
        stop_macro = "cq",
        toggle_record = "Q",
        cycle_next = "<leader>qn",
        cycle_prev = "<leader>qp",
        toggle_macro_menu = "<A-q>",
      },
    })
    require("telescope").load_extension("macros")
  end,
  keys = {
    {
      "@",
      function()
        require("NeoComposer.macro").play_macro()
      end,
      desc = "NeoComposer Play Macro",
    },
    {
      "<leader>yq",
      function()
        require("NeoComposer.macro").yank_macro()
      end,
      desc = "NeoComposer Yank Macro",
    },
    {
      "<leader>sq",
      function()
        require("NeoComposer.macro").stop_macro()
      end,
      desc = "NeoComposer Stop Macro",
    },
    {
      "<A-q>",
      function()
        require("NeoComposer.macro").toggle_record()
      end,
      desc = "NeoComposer Record Macro",
    },
    {
      "<leader>qn",
      function()
        require("NeoComposer.ui").cycle_next()
      end,
      desc = "NeoComposer Cycle Next",
    },
    {
      "<leader>qp",
      function()
        require("NeoComposer.ui").cycle_prev()
      end,
      desc = "NeoComposer Cycle Prev",
    },
    {
      "<leader>q",
      function()
        require("NeoComposer.ui").toggle_macro_menu()
      end,
      desc = "NeoComposer Toggle Menu",
    },
  },
  dependencies = { "kkharji/sqlite.lua" },
}