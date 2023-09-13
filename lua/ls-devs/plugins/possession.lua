local M = {}

M.config = function()
  require("nvim-possession").setup({
    sessions = {
      sessions_icon = " ",
    },
    autoload = false, -- whether to autoload sessions in the cwd at startup
    autosave = true, -- whether to autosave loaded sessions before quitting
    autoswitch = {
      enable = true, -- whether to enable autoswitch
    },

    save_hook = function()
      local visible_buffers = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        visible_buffers[vim.api.nvim_win_get_buf(win)] = true
      end

      local buflist = vim.api.nvim_list_bufs()
      for _, bufnr in ipairs(buflist) do
        if visible_buffers[bufnr] == nil then -- Delete buffer if not visible
          vim.cmd("bd " .. bufnr)
        end
      end
    end,
    post_hook = function()
      require("nvim-tree").toggle(false, true)
    end,

    fzf_winopts = {
      width = 0.5,
      preview = {
        vertical = "right:30%",
      },
    },
  })
end

return M
