return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  keys = {
    { "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview" },
  },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
}
