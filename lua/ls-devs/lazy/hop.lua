local M = {}
M.config = function()
  local hop = require("hop")

  if not hop then
    return
  end

  hop.setup({})
end

M.keys = {
  { "<leader>hh", "<cmd>HopChar2<cr>", desc = "HopChar2" },
  { "<leader>hf", "<cmd>HopChar1<cr>", desc = "HopChar1" },
  { "<leader>hp", "<cmd>HopPattern<cr>", desc = "HopPattern" },
  { "<leader>hl", "<cmd>HopLineStart<cr>", desc = "HopLineStart" },
  { "<leader>hv", "<cmd>HopVertical<cr>", desc = "HopVertical" },
  { "<leader>hw", "<cmd>HopWord<cr>", desc = "HopWord" }
}
return M
