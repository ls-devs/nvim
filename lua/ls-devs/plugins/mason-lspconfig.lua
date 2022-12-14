local M = {}

M.config = function()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "html",
      "cssls",
      "cssmodules_ls",
      "emmet_ls",
      "tsserver",
      "volar",
      "tailwindcss",
      "prismals",
      "jsonls",
      "intelephense",
      "sqlls",
      "yamlls",
      "dockerls",
      "marksman",
      "rust_analyzer",
      "pyright",
      "clangd",
      "cmake",
      "sumneko_lua",
    },
    automatic_installation = true,
  })
end

return M
