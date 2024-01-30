return {
  "zbirenbaum/copilot-cmp",
  cmd = "Copilot",
  opts = {
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
  },
  keys = {
    {
      "<leader>cp",
      "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>",
      desc = "Toggle Copilot",
      noremap = true,
      silent = true,
    },
  },
  dependencies = {
    "zbirenbaum/copilot.lua",
    opts = require("ls-devs.plugins.completion.config.copilot"),
  },
}
