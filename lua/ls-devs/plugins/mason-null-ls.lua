local M = {}

M.config = function()
  local mason_null_ls = require("mason-null-ls")
  mason_null_ls.setup({
    automatic_installation = true,
    ensure_installed = {
      "black",
      "stylua",
      "xmlformatter",
      "eslint_d",
      "shellharden",
      "cmakelang",
      "cmakelint",
      "markdownlint",
      "yamllint",
      "yamlfmt",
      "jsonlint",
      "jq",
      "phpcs",
      "php-cs-fixer",
      "proselint",
      "hadolint",
      "fourmolu",
      "clang-format",
      "cpplint",
      "bash-debug-adapter",
      "pylint",
      "commitlint",
      "beautysh",
      "sql_formatter",
    },
  })
end

return M
