return {
  "nvim-telescope/telescope.nvim",
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lst = require("telescope").extensions.luasnip
    local luasnip = require("luasnip")

    telescope.setup({
      layout_stategy = "center",
      defaults = {
        file_ignore_patterns = {
          ".git/",
          "node_modules/*",
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<A-a>"] = actions.toggle_all,
            ["<C-s>"] = actions.select_vertical,
          },
          n = {
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<A-a>"] = actions.toggle_all,
            ["<C-s>"] = actions.select_vertical,
          },
        },
      },
      extensions = {
        emoji = {
          action = function(emoji)
            vim.fn.setreg("*", emoji.value)
            print([[Press p or "*p to paste this emoji ]] .. emoji.value)
          end,
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        aerial = {
          show_nesting = {
            ["_"] = false,
            json = true,
            yaml = true,
          },
        },
        luasnip = {
          search = function(entry)
            return lst.filter_null(entry.context.trigger)
                .. " "
                .. lst.filter_null(entry.context.name)
                .. " "
                .. entry.ft
                .. " "
                .. lst.filter_description(entry.context.name, entry.context.description)
                .. lst.get_docstring(luasnip, entry.ft, entry.context)[1]
          end,
        },
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("media_files")
    telescope.load_extension("aerial")
    telescope.load_extension("neoclip")
    telescope.load_extension("macros")
    telescope.load_extension("emoji")
    telescope.load_extension("noice")
    telescope.load_extension("luasnip")
    telescope.load_extension("cmdline")
  end,
  keys = {
    {
      "<leader>ff",
      "<cmd>Telescope find_files<CR>",
      desc = "Telescope Find Files",
    },
    {
      "<leader>ft",
      "<cmd>Telescope live_grep<CR>",
      desc = "Telescope Live Grep",
    },
    {
      "<leader>fl",
      "<cmd>Telescope luasnip<CR>",
      desc = "Telescope LuaSnip",
    },
    {
      "<leader>fn",
      "<cmd>Telescope neoclip<CR>",
      desc = "Telescope Neoclip",
    },
    {
      "<leader>fb",
      "<cmd>Telescope buffers<CR>",
      desc = "Telescope Buffers",
    },
    {
      "<leader>fx",
      "<cmd>Telescope help_tags<CR>",
      desc = "Telescope Help Tags",
    },
    {
      "<leader>fp",
      "<cmd>Telescope oldfiles<CR>",
      desc = "Telescope Recent Files",
    },
    {
      "<leader>fa",
      "<cmd>Telescope autocommands<CR>",
      desc = "Telescope Autocommands",
    },
    {
      "<leader>fc",
      "<cmd>Telescope commands<CR>",
      desc = "Telescope Commands",
    },
    {
      "<leader>fk",
      "<cmd>Telescope keymaps<CR>",
      desc = "Telescope Keymaps",
    },
    {
      "<leader>fF",
      "<cmd>Telescope filetypes<CR>",
      desc = "Telescope Filetypes",
    },
    {
      "<leader>fo",
      "<cmd>Telescope vim_options<CR>",
      desc = "Telescope Vim Options",
    },
    {
      "<leader>fH",
      "<cmd>Telescope highlights<CR>",
      desc = "Telescope Highlights",
    },
    {
      "<leader>tz",
      "<cmd>Telescope aerial<CR>",
      desc = "Telescope aerial",
    },
    {
      "<leader>fB",
      "<cmd>Telescope current_buffer_fuzzy_find<CR>",
      desc = "Telescope Current Buffer Fuzzy Find",
    },
    {
      "<leader>fC",
      "<cmd>Telescope command_history<CR>",
      desc = "Telescope Command History",
    },
    {
      "<leader>fM",
      "<cmd>Telescope marks<CR>",
      desc = "Telescope Marks",
    },
    {
      "<leader>tm",
      "<cmd>Telescope media_files<CR>",
      desc = "Telescope Media Files",
    },
    {
      "<leader>gs",
      "<cmd>lua require('telescope.builtin').git_status()<CR>",
      desc = "Telescope Git Status",
    },
    {
      "<leader>gc",
      "<cmd>lua require('telescope.builtin').git_commits()<CR>",
      desc = "Telescope Git Commits",
    },
    {
      "<leader>gb",
      "<cmd>lua require('telescope.builtin').git_branches()<CR>",
      desc = "Telescope Git Branches",
    },
    {
      "<leader>fe",
      "<cmd>Telescope emoji<CR>",
      desc = "Telescope Emojis",
    },
  },
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    { "jonarrien/telescope-cmdline.nvim" },
    {
      "benfowler/telescope-luasnip.nvim",
    },
    { "nvim-telescope/telescope-media-files.nvim" },
    { "xiyaowong/telescope-emoji.nvim" },
    {
      "AckslD/nvim-neoclip.lua",
      dependencies = {
        { "nvim-telescope/telescope.nvim" },
        { "ibhagwan/fzf-lua" },
        {
          "kkharji/sqlite.lua",
        },
      },
      opts = {
        history = 1000,
        enable_persistent_history = false,
        length_limit = 1048576,
        continuous_sync = true,
        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
        filter = nil,
        preview = true,
        prompt = nil,
        default_register = '"',
        default_register_macros = "q",
        enable_macro_history = true,
        content_spec_column = false,
        disable_keycodes_parsing = false,
        on_select = {
          move_to_front = false,
          close_telescope = true,
        },
        on_paste = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_replay = {
          set_reg = false,
          move_to_front = false,
          close_telescope = true,
        },
        on_custom_action = {
          close_telescope = true,
        },
        keys = {
          telescope = {
            i = {
              select = "<cr>",
              paste = "<c-p>",
              paste_behind = "<c-k>",
              replay = "<c-q>", -- replay a macro
              delete = "<c-d>", -- delete an entry
              edit = "<c-e>", -- edit an entry
              custom = {},
            },
            n = {
              select = "<cr>",
              --- It is possible to map to more than one key.
              paste = { "p", "<c-p>" },
              paste_behind = "P",
              replay = "q",
              delete = "d",
              edit = "e",
              custom = {},
            },
          },
          fzf = {
            select = "default",
            paste = "ctrl-p",
            paste_behind = "ctrl-k",
            custom = {},
          },
        },
      },
    },
  },
}
