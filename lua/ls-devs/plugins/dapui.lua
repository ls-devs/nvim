local M = {}

M.config = function()
  require("dapui").setup()
end

M.keys = {
  { "<leader>uo", "<cmd>lua require('dapui').toggle()<CR>", desc = "DapUI Toggle" },
  { "<leader>uc", "<cmd>lua require('dapui').close()<CR>",  desc = "DapUI Close" },
  { "<leader>un", ":DapContinue<CR>",                       desc = "DapContinue" },
  { "<leader>ut", ":DapTerminate<CR>",                      desc = "DapTerminate" },
  { "<leader>bb", ":DapToggleBreakpoint<CR>",               desc = "DapToggleBreakpoint" },
}

return M
