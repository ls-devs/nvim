local M = {}
M.config = function()
  require("glow").setup({
    border = "rounded", -- floating window border config
    width = 115,
    height = 115,
    height_ratio = 1,
    width_ration = 1,
  })
end

M.keys = {
  { "<leader>mg", "<cmd>Glow<CR>", desc = "Glow" },
}

return M
