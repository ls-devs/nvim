local M = {}

M.config = function()
  local lsp_zero = require("lsp-zero")
  require("mason-lspconfig").setup({
    ensure_installed = {
      "astro",
      "html",
      "lemminx",
      "mdx_analyzer",
      "cssls",
      "cssmodules_ls",
      "emmet_language_server",
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
      "kotlin_language_server",
    },
    automatic_installation = true,
    handlers = {
      lsp_zero.default_setup,
      rust_analyzer = lsp_zero.noop,
      hls = lsp_zero.noop,
      clangd = lsp_zero.noop,
    },
  })
end

return M
