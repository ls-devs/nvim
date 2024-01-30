return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  keys = {
    {
      "<leader>md",
      "<cmd>MarkdownPreviewToggle<CR>",
      desc = "Markdown Preview",
      noremap = true,
      silent = true,
    },
  },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
