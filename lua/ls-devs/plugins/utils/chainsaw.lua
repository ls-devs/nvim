return {
  "chrisgrieser/nvim-chainsaw",
  opts = {
    marker = "🪚",
    beepEmojis = { "🔵", "🟩", "⭐", "⭕", "💜", "🔲" },
  },
  keys = {
    {
      "<leader>Cm",
      "<cmd>lua require('chainsaw').messageLog()<CR>",
      desc = "Chainsaw message log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Cv",
      "<cmd>lua require('chainsaw').variableLog()<CR>",
      desc = "Chainsaw variable log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Co",
      "<cmd>lua require('chainsaw').objectLog()<CR>",
      desc = "Chainsaw object log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Ca",
      "<cmd>lua require('chainsaw').assertLog()<CR>",
      desc = "Chainsaw assert log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Cb",
      "<cmd>lua require('chainsaw').beepLog()<CR>",
      desc = "Chainsaw beep log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Ct",
      "<cmd>lua require('chainsaw').timeLog()<CR>",
      desc = "Chainsaw time log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Cd",
      "<cmd>lua require('chainsaw').debugLog()<CR>",
      desc = "Chainsaw debug log",
      silent = true,
      noremap = true,
    },
    {
      "<leader>Cr",
      "<cmd>lua require('chainsaw').removeLogs()<CR>",
      desc = "Chainsaw remove log",
      silent = true,
      noremap = true,
    },
  },
}
