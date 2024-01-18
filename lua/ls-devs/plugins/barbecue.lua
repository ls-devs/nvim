local M = {}

M.config = function()
  local c = require("tokyonight.colors").setup()
  -- triggers CursorHold event faster
  vim.opt.updatetime = 200
  require("barbecue").setup({
    attach_navic = true,

    create_autocmd = false,

    include_buftypes = { "" },

    exclude_filetypes = { "netrw", "toggleterm" },

    modifiers = {
      dirname = ":~:.",
      basename = "",
    },

    show_dirname = true,
    show_basename = true,
    show_modified = true,
    modified = function(bufnr)
      return vim.bo[bufnr].modified
    end,
    show_navic = true,
    lead_custom_section = function()
      return " "
    end,

    custom_section = function()
      return " "
    end,

    theme = {
      normal = { fg = "#c0caf5" },
      ellipsis = { fg = "#737aa2" },
      separator = { fg = "#737aa2", bold = true },
      modified = { fg = c.orange },
      dirname = { fg = "#737aa2" },
      basename = { bold = true },
      context = {},
      context_file = { fg = "#ac8fe4" },
      context_module = { fg = "#ac8fe4" },
      context_namespace = { fg = "#ac8fe4" },
      context_package = { fg = "#ac8fe4" },
      context_class = { fg = "#ac8fe4" },
      context_method = { fg = "#ac8fe4" },
      context_property = { fg = "#ac8fe4" },
      context_field = { fg = "#ac8fe4" },
      context_constructor = { fg = "#ac8fe4" },
      context_enum = { fg = "#ac8fe4" },
      context_interface = { fg = "#ac8fe4" },
      context_function = { fg = "#ac8fe4" },
      context_variable = { fg = "#ac8fe4" },
      context_constant = { fg = "#ac8fe4" },
      context_string = { fg = "#ac8fe4" },
      context_number = { fg = "#ac8fe4" },
      context_boolean = { fg = "#ac8fe4" },
      context_array = { fg = "#ac8fe4" },
      context_object = { fg = "#ac8fe4" },
      context_key = { fg = "#ac8fe4" },
      context_null = { fg = "#ac8fe4" },
      context_enum_member = { fg = "#ac8fe4" },
      context_struct = { fg = "#ac8fe4" },
      context_event = { fg = "#ac8fe4" },
      context_operator = { fg = "#ac8fe4" },
      context_type_parameter = { fg = "#ac8fe4" },
    },
    context_follow_icon_color = true,

    symbols = {
      modified = "",
      ellipsis = "…",
      separator = "",
    },

    kinds = {
      Dirname = "",
      File = "",
      Module = "",
      Namespace = "",
      Package = "",
      Class = "",
      Method = "",
      Property = "",
      Field = "",
      Constructor = "",
      Enum = "",
      Interface = "",
      Function = "",
      Variable = "",
      Constant = "",
      String = "",
      Number = "",
      Boolean = "",
      Array = "",
      Object = "",
      Key = "",
      Null = "",
      EnumMember = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = "",
    },
  })
end

return M
