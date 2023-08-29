local M = {}

M.config = function()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "html",
      "lemminx",
      "mdx_analyzer",
      "cssls",
      "cssmodules_ls",
      "emmet_ls",
      "emmet_language_server",
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
      "bashls",
      "vimls",
      "graphql",
      "wgsl_analyzer",
      "svelte",
      "taplo",
      "vls",
    },
    automatic_installation = true,
  })
end

return M
