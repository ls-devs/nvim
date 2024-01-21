return function()
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
        },
        n = {
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<A-a>"] = actions.toggle_all,
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
  telescope.load_extension("lazygit")
end
