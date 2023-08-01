local M = {}

M.config = function ()
  require("hbac").setup({
  autoclose     = true, -- set autoclose to false if you want to close manually
  threshold     = 10, -- hbac will start closing unedited buffers once that number is reached
  close_command = function(bufnr)
    vim.api.nvim_buf_delete(bufnr, {})
  end,
  close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
  telescope = {
    mappings = {
      n = {
        close_unpinned = "<M-c>",
        delete_buffer = "<M-x>",
        pin_all = "<M-a>",
        unpin_all = "<M-u>",
        toggle_selections = "<M-y>",
      },
      i = {
        -- as above
      },
    },
    -- Pinned/unpinned icons and their hl groups. Defaults to nerdfont icons
    pin_icons = {
      pinned = { "󰐃 ", hl = "DiagnosticOk" },
      unpinned = { "󰤱 ", hl = "DiagnosticError" },
    },
  },
})
end

return M
