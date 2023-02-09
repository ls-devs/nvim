local M = {}

M.config = function()
  local null_ls = require("null-ls")

  --luacheck: ignore augroup
  ---@diagnostic disable-next-line: unused-local
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  null_ls.setup({
      border = "rounded",
      sources = {
          -- PYTHON
          null_ls.builtins.code_actions.refactoring.with({
              filetypes = { "python" },
          }),
          null_ls.builtins.formatting.black,
          -- JS / TS
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.prettierd,
          -- JSON
          null_ls.builtins.diagnostics.jsonlint,
          null_ls.builtins.formatting.jq,
          -- LUA
          null_ls.builtins.code_actions.refactoring.with({
              filetypes = { "lua" },
          }),
          null_ls.builtins.diagnostics.luacheck,
          null_ls.builtins.formatting.stylua,
          -- PRISMA
          null_ls.builtins.formatting.prismaFmt,
          -- RUST
          null_ls.builtins.formatting.rustfmt,
          -- CMAKE
          null_ls.builtins.diagnostics.cmake_lint,
          null_ls.builtins.formatting.cmake_format,
          -- MARKDOWN
          null_ls.builtins.code_actions.proselint,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.formatting.markdownlint,
          -- YAML
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.formatting.yamlfmt,
          -- PHP
          null_ls.builtins.diagnostics.phpcs,
          null_ls.builtins.formatting.phpcsfixer,
          -- DOCKER
          null_ls.builtins.diagnostics.hadolint,
          -- Haskell
          null_ls.builtins.formatting.fourmolu,
          -- Bash
          null_ls.builtins.formatting.shellharden,
          -- XML
          null_ls.builtins.formatting.xmlformat.with({
              filetypes = { "svg", "xml" },
          }),
      },
  })
end

return M
