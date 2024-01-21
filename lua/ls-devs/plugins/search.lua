local M = {}

M.config = function()
  local builtin = require("telescope.builtin")
  local extensions = require("telescope").extensions
  require("search").setup({
    mappings = { -- optional: configure the mappings for switching tabs (will be set in normal and insert mode(!))
      next = "<Tab>",
      prev = "<S-Tab>",
    },
    tabs = {
      {
        "Files",
        function(opts)
          opts = opts or {}
          if vim.fn.isdirectory(".git") == 1 then
            builtin.git_files(opts)
          else
            builtin.find_files(opts)
          end
        end,
      },
      {
        "Live Grep",
        builtin.live_grep,
        available = function()
          return true
        end,
      },
      {
        "Old Files",
        builtin.oldfiles,
        available = function()
          return true
        end,
      },
      {
        "Buffers",
        builtin.buffers,
        available = function()
          function get_bufs_loaded()
            local bufs_loaded = {}

            for i, buf_hndl in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf_hndl) then
                bufs_loaded[i] = buf_hndl
              end
            end

            return bufs_loaded
          end

          for index, value in ipairs(get_bufs_loaded()) do
            if value == 1 then
              return false
            else
              return true
            end
          end
        end,
      },
      {
        "Commits",
        builtin.git_commits,
        available = function()
          return vim.fn.isdirectory(".git") == 1
        end,
      },
      {
        "Media Files",
        extensions.media_files.media_files,
        available = function()
          return true
        end,
      },
      {
        "Noice",
        extensions.noice.noice,
        available = function()
          return true
        end,
      },
      {
        "LuaSnip",
        extensions.luasnip.luasnip,
        available = function()
          return true
        end,
      },
      {
        "Emojis",
        extensions.emoji.emoji,
        available = function()
          return true
        end,
      },
    },
  })
end

return M
