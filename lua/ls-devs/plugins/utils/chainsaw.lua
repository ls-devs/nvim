return {
  "chrisgrieser/nvim-chainsaw",
  opts = {
    marker = "🪚",
    beepEmojis = { "🔵", "🟩", "⭐", "⭕", "💜", "🔲" },
  },
  keys = {
    { "<leader>Cm", "<cmd>lua require('chainsaw').messageLog()<CR>",  desc = "Chainsaw message log" },
    { "<leader>Cv", "<cmd>lua require('chainsaw').variableLog()<CR>", desc = "Chainsaw variable log" },
    { "<leader>Co", "<cmd>lua require('chainsaw').objectLog()<CR>",   desc = "Chainsaw object log" },
    { "<leader>Ca", "<cmd>lua require('chainsaw').assertLog()<CR>",   desc = "Chainsaw assert log" },
    { "<leader>Cb", "<cmd>lua require('chainsaw').beepLog()<CR>",     desc = "Chainsaw beep log" },
    { "<leader>Ct", "<cmd>lua require('chainsaw').timeLog()<CR>",     desc = "Chainsaw time log" },
    { "<leader>Cd", "<cmd>lua require('chainsaw').debugLog()<CR>",    desc = "Chainsaw debug log" },
    { "<leader>Cr", "<cmd>lua require('chainsaw').removeLogs()<CR>",  desc = "Chainsaw remove log" },
  },
}
