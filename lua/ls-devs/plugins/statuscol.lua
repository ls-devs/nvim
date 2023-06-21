local M = {}

M.config = function()
  require("statuscol").setup({
    -- foldfunc = "builtin",
    -- setopt = true,
    relculright = true,
    segments = {
      { text = { require("statuscol.builtin").foldfunc },      click = "v:lua.ScFa" },
      { text = { "%s" },                                       click = "v:lua.ScSa" },
      { text = { require("statuscol.builtin").lnumfunc, " " }, click = "v:lua.ScLa" },
    },
  })
end

return M
