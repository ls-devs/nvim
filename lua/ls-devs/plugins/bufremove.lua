local M = {}

M.keys = {

  {
    "<leader>bd",
    function()
      require("mini.bufremove").delete(0, false)
    end,
    desc = "Delete Buffer",
  },
  {
    "<leader>bD",
    function()
      require("mini.bufremove").delete(0, true)
    end,
    desc = "Delete Buffer (Force)",
  },
}

return M
