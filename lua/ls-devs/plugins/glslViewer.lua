local M = {}

M.config = function()
  require("glslView").setup({
    exe_path = "/usr/bin/glslViewer",
    arguments = { "-l", "-w", "128", "-h", "256" },
  })
end

M.keys = {
  { "<leader>gw", "<cmd>GlslView -w 128 -h 256<CR>", desc = "GlslView" },
}

return M
