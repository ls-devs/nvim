local M = {}
local builtin = require("statuscol.builtin")

M.config = function()
  require("statuscol").setup({

    -- foldfunc = "builtin",
    -- setopt = true,
    relculright = true,
    segments = {
      { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
      { text = { "%s" },                  click = "v:lua.ScSa" },
      { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
    },
  })
end

return M
