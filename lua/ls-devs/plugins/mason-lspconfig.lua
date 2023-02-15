local M = {}

M.config = function()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "html",
      "lemminx",
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
      "docker_compose_language_service",
      "marksman",
      "rust_analyzer",
      "pyright",
      "clangd",
      "cmake",
      "lua_ls",
      "hls",
      "clangd",
    },
    automatic_installation = true,
  })
end

return M
