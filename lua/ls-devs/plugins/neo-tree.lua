local M = {}

M.config = function()
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

  require("neo-tree").setup({
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    enable_normal_mode_for_inputs = true,                            -- Enable normal mode for input dialogs.
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
    sort_case_insensitive = false,                                   -- used when sorting files and directories in the tree
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "󰜌",
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = "*",
        highlight = "NeoTreeFileIcon",
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = "✖", -- this can only be used in the git_status source
          renamed = "󰁕", -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = {
        enabled = true,
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        required_width = 122, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = true,
        required_width = 110, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
    -- A list of functions, each representing a global custom command
    -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
    -- see `:h neo-tree-custom-commands-global`
    commands = {
      create_and_focus = function(state)
        local fs = require("neo-tree.sources.filesystem")
        local fs_actions = require("neo-tree.sources.filesystem.lib.fs_actions")
        local commands = require("neo-tree.sources.common.commands")


        local function get_folder_node(nodeState)
          local tree = nodeState.tree
          local node = tree:get_node()
          local last_id = node:get_id()

          while node do
            local insert_as_local = nodeState.config.insert_as
            local insert_as_global = require("neo-tree").config.window.insert_as
            local use_parent
            if insert_as_local then
              use_parent = insert_as_local == "sibling"
            else
              use_parent = insert_as_global == "sibling"
            end

            local is_open_dir = node.type == "directory" and (node:is_expanded() or node.empty_expanded)
            if use_parent and not is_open_dir then
              return tree:get_node(node:get_parent_id())
            end

            if node.type == "directory" then
              return node
            end

            local parent_id = node:get_parent_id()
            if not parent_id or parent_id == last_id then
              return node
            else
              last_id = parent_id
              node = tree:get_node(parent_id)
            end
          end
        end

        local function get_using_root_directory(rootState)
          local using_root_directory = get_folder_node(rootState):get_id()
          local show_path = rootState.config.show_path
          if show_path == "absolute" then
            using_root_directory = ""
          elseif show_path == "relative" then
            using_root_directory = rootState.path
          end
          return using_root_directory
        end

        local function add(addState, callback)
          local node = get_folder_node(addState)
          local in_directory = node:get_id()
          local using_root_directory = get_using_root_directory(addState)
          fs_actions.create_node(in_directory, callback, using_root_directory)
        end

        add(state, function(destination)
          fs.show_new_children(state, destination)
          vim.cmd.edit(destination)
        end)
      end,
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
      open_and_clear_filter = function(state)
        local node = state.tree:get_node()
        if node and node.type == "file" then
          local file_path = node:get_id()
          -- reuse built-in commands to open and clear filter
          local cmds = require("neo-tree.sources.filesystem.commands")
          cmds.open(state)
          cmds.clear_filter(state)
          -- reveal the selected file without focusing the tree
          require("neo-tree.sources.filesystem").navigate(state, state.path, file_path)
        end
      end,
      diff_files = function(state)
        local node = state.tree:get_node()
        local log = require("neo-tree.log")
        state.clipboard = state.clipboard or {}
        if diff_Node and diff_Node ~= tostring(node.id) then
          local current_Diff = node.id
          require("neo-tree.utils").open_file(state, diff_Node, open)
          vim.cmd("vert diffs " .. current_Diff)
          log.info("Diffing " .. diff_Name .. " against " .. node.name)
          diff_Node = nil
          current_Diff = nil
          state.clipboard = {}
          require("neo-tree.ui.renderer").redraw(state)
        else
          local existing = state.clipboard[node.id]
          if existing and existing.action == "diff" then
            state.clipboard[node.id] = nil
            diff_Node = nil
            require("neo-tree.ui.renderer").redraw(state)
          else
            state.clipboard[node.id] = { action = "diff", node = node }
            diff_Name = state.clipboard[node.id].node.name
            diff_Node = tostring(state.clipboard[node.id].node.id)
            log.info("Diff source file " .. diff_Name)
            require("neo-tree.ui.renderer").redraw(state)
          end
        end
      end,
    },

    window = {
      position = "float",
      width = 40,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = {
          "toggle_node",
          nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ["<2-LeftMouse>"] = "open",
        ["l"] = "open",
        ["<esc>"] = "cancel", -- close preview or floating neo-tree window
        ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
        [","] = "focus_preview",
        ["S"] = "split_with_window_picker",
        ["s"] = "vsplit_with_window_picker",
        ["t"] = "open_tabnew",
        ["w"] = "open_with_window_picker",
        -- ["C"] = "close_node",
        ["C"] = "close_all_subnodes",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["o"] = "open_and_clear_filter",
        ["D"] = "diff_files",
        ["a"] = {
          "create_and_focus",
          config = {
            show_path = "relative",
          },
        },
        ["m"] = {
          "move",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },

        ["A"] = {
          "add_directory",
          config = {
            show_path = "relative",
          },
        }, -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = {
          "copy",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        ["i"] = "show_file_details",
      },
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          "node_modules",
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = true,                    -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false,           -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = false,            -- when true, empty folders will be grouped together
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["r"] = "rename",
          ["m"] = {
            "move",
            config = {
              show_path = "relative",
            },
          }, -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          -- ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["og"] = { "order_by_git_status", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ["<down>"] = "move_cursor_down",
          ["<C-j>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-k>"] = "move_cursor_up",
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
        open_and_clear_filter = function(state)
          local node = state.tree:get_node()
          if node and node.type == "file" then
            local file_path = node:get_id()
            -- reuse built-in commands to open and clear filter
            local cmds = require("neo-tree.sources.filesystem.commands")
            cmds.open(state)
            cmds.clear_filter(state)
            -- reveal the selected file without focusing the tree
            require("neo-tree.sources.filesystem").navigate(state, state.path, file_path)
          end
        end,
        diff_files = function(state)
          local node = state.tree:get_node()
          local log = require("neo-tree.log")
          state.clipboard = state.clipboard or {}
          if diff_Node and diff_Node ~= tostring(node.id) then
            local current_Diff = node.id
            require("neo-tree.utils").open_file(state, diff_Node, open)
            vim.cmd("vert diffs " .. current_Diff)
            log.info("Diffing " .. diff_Name .. " against " .. node.name)
            diff_Node = nil
            current_Diff = nil
            state.clipboard = {}
            require("neo-tree.ui.renderer").redraw(state)
          else
            local existing = state.clipboard[node.id]
            if existing and existing.action == "diff" then
              state.clipboard[node.id] = nil
              diff_Node = nil
              require("neo-tree.ui.renderer").redraw(state)
            else
              state.clipboard[node.id] = { action = "diff", node = node }
              diff_Name = state.clipboard[node.id].node.name
              diff_Node = tostring(state.clipboard[node.id].node.id)
              log.info("Diff source file " .. diff_Name)
              require("neo-tree.ui.renderer").redraw(state)
            end
          end
        end,
      },
    },
    event_handlers = {
      {
        event = "file_added",
        handler = function(path)
          local fs = require("neo-tree.sources.filesystem")
        end,
      },
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
    buffers = {
      follow_current_file = {
        enabled = true,      -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
  })
end

M.keys = {
  { "<leader>e",  "<cmd>Neotree float reveal<CR>", desc = "NeoTreeFloatToggle reveal" },
  { "<leader>to", "<cmd>Neotree show<CR>",         desc = "NeoTreeShow" },
  { "<leader>tc", "<cmd>Neotree close<CR>",        desc = "NeoTreeShow" },
  { "<leader>tc", "<cmd>Neotree close<CR>",        desc = "NeoTreeClose" },
}

return M
