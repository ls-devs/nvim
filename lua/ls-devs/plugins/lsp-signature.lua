local M = {}

M.config = function()
  require("lsp_signature").setup({
    max_width = 40,     -- max_width of signature floating_window
    close_timeout = 1500, -- close floating window after ms when laster parameter is entered
    hint_prefix = "🐭 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
    hint_enable = false,
    floating_window = false,
    always_trigger = false,
    timer_interval = 10, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = "<C-x>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    floating_window_above_cur_line = true,
    noice = true,
  }) -- no need to specify bufnr if you don't use toggle_ke
end

return M
