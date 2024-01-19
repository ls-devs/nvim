local M = {}

M.config = function()
  require("chainsaw").setup({
    -- The marker should be a unique string, since `.removeLogs()` will remove
    -- any line with it. Emojis or strings like "[Chainsaw]" are recommended.
    marker = "🪚",

    -- emojis used for `.beepLog()`
    beepEmojis = { "🔵", "🟩", "⭐", "⭕", "💜", "🔲" },
  })
end

M.keys = {
  { "<leader>Cm", "<cmd>lua require('chainsaw').messageLog()<CR>",  desc = "Chainsaw message log" },
  { "<leader>Cv", "<cmd>lua require('chainsaw').variableLog()<CR>", desc = "Chainsaw variable log" },
  { "<leader>Co", "<cmd>lua require('chainsaw').objectLog()<CR>",   desc = "Chainsaw object log" },
  { "<leader>Ca", "<cmd>lua require('chainsaw').assertLog()<CR>",   desc = "Chainsaw assert log" },
  { "<leader>Cb", "<cmd>lua require('chainsaw').beepLog()<CR>",     desc = "Chainsaw beep log" },
  { "<leader>Ct", "<cmd>lua require('chainsaw').timeLog()<CR>",     desc = "Chainsaw time log" },
  { "<leader>Cd", "<cmd>lua require('chainsaw').debugLog()<CR>",    desc = "Chainsaw debug log" },
  { "<leader>Cr", "<cmd>lua require('chainsaw').removeLogs()<CR>",  desc = "Chainsaw remove log" },
}

return M
