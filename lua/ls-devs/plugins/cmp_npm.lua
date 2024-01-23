local M = {}

M.config = function()
  require("cmp-npm").setup({
    ignore = {},
    only_semantic_versions = false,
    only_latest_version = false,
  })
end

return M
