local M = {}

M.config = function()
  local ranger_nvim = require("ranger-nvim")
  ranger_nvim.setup({
    enable_cmds = false,
    replace_netrw = false,
    keybinds = {
      ["ov"] = ranger_nvim.OPEN_MODE.vsplit,
      ["oh"] = ranger_nvim.OPEN_MODE.split,
      ["ot"] = ranger_nvim.OPEN_MODE.tabedit,
      ["or"] = ranger_nvim.OPEN_MODE.rifle,
    },
    ui = {
      border = "rounded",
      height = 0.65,
      width = 0.7,
      x = 0.5,
      y = 0.5,
    },
  })
end

return M
