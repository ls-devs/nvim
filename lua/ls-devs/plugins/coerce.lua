local M = {}

M.config = function()
  require("coerce").setup({
    coerce_prefix = "cr",
    keymap_registry = require("coerce.keymap").keymap_registry(),
  })
end

M.keys = {
  { "crc", desc = "Coerce CamelCase" },
  { "crd", desc = "Coerce Dot.Case" },
  { "crk", desc = "Coerce Kebab-Case" },
  { "crn", desc = "Coerce N12E" },
  { "crp", desc = "Coerce PascalCase" },
  { "crs", desc = "Coerce Snake_Case" },
  { "cru", desc = "Coerce UPPERCASE" },
  { "cr/", desc = "Coerce Path/Case" },
}

return M
