local M = {}
M.config = function()
  require("glow").setup({
    border = "rounded", -- floating window border config
    style = "dark",
  })
end

M.keys = {
  { "<leader>md", "<cmd>Glow<CR>", desc = "Glow" }
}

return M
