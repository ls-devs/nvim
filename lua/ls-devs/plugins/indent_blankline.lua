local M = {}

M.config = function()
  require("indent_blankline").setup({
    show_current_context = true,
    -- show_current_context_start = true,
    space_char_blankline = " ",
    char_highlight_list = {
      "IndentBlanklineIndent1",
      "IndentBlanklineIndent2",
      "IndentBlanklineIndent3",
      "IndentBlanklineIndent4",
      "IndentBlanklineIndent5",
      "IndentBlanklineIndent6",
    },
  })
end

return M
