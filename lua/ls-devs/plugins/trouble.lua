local M = {}

M.config = function()
  require("trouble").setup({
    auto_close = true,
    auto_fold = true,
    auto_preview = false,
    use_diagnostic_signs = true,
    action_keys = {
      toggle_fold = { "zA", "za", "l" }, -- toggle fold of current filetoggle_fold = {"zA", "za"}, -- toggle fold of current file
    },
  })
end

M.keys = {
  {
    "<leader>v",
    "<cmd>Trouble<CR>",
    desc = "Trouble",
  },
}

return M
