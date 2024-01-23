local M = {}

M.config = function()
  require("copilot_cmp").setup({
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
  })
end

return M
