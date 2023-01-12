local M = {}

local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        -- any way to open the file without triggering auto-close event of neo-tree?
        require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
      end)
      return true
    end,
  }
end

M.config = function()
  local neo_tree = require("neo-tree")

  neo_tree.setup({
    close_if_last_window = true,
    hide_root_node = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
      position = "right",
      mappings = {
        ["l"] = "open",
        ["S"] = "split_with_window_picker",
        ["s"] = "vsplit_with_window_picker",
        ["w"] = "open_with_window_picker",
        ["o"] = "system_open",
        ["tf"] = "telescope_find",
        ["tg"] = "telescope_grep",
        ["e"] = function()
          vim.api.nvim_exec("Neotree focus filesystem right", true)
        end,
        ["b"] = function()
          vim.api.nvim_exec("Neotree focus buffers right", true)
        end,
        ["g"] = function()
          vim.api.nvim_exec("Neotree focus git_status right", true)
        end,
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        always_show = {
          ".gitignore",
        },
        never_show = {
          ".git",
          ".DS_Store",
          "lazy-lock.json",
        },
      },
      hijack_netrw_behavior = "open_current",
      follow_current_file = true,
      use_libuv_file_watcher = true,
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "file_opened",
          handler = function(file_path)
            --auto close
            require("neo-tree").close_all()
          end,
        },
      },
      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          -- macOs: open file in default application in the background.
          -- Probably you need to adapt the Linux recipe for manage path with spaces. I don't have a mac to try.
          vim.api.nvim_command("silent !open -g " .. path)
          -- Linux: open file in default application
          vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
        end,
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").find_files(getTelescopeOpts(state, path))
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
        end,
      },
    },
  })
end

M.keys = {
  { "<leader>e", "<cmd>NeoTreeFloatToggle<CR>", desc = "NeoTreeFloatToggle" },
  { "<leader>to", "<cmd>NeoTreeShow<CR>", desc = "NeoTreeShow" },
  { "<leader>tc", "<cmd>NeoTreeClose<CR>", desc = "NeoTreeClose" },
}

return M
