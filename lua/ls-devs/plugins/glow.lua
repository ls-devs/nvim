local M = {}
M.config = function()
  require("glow").setup({
    border = "rounded", -- floating window border config
    width = 115,
    height = 115,
    height_ratio = 0.9,
    width_ration = 0.9,
  })
end

M.keys = {
  { "<leader>md", "<cmd>Glow<CR>", desc = "Glow" },
}

return M
