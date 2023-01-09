local M = {}
M.config = function()
  require("nvim-dap-virtual-text").setup({
    virt_text_win_col = 80,
    all_frames = true,
    commented = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
  })
end

return M
