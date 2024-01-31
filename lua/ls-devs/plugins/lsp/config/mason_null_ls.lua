return function()
  local mason_null_ls = require("mason-null-ls")
  mason_null_ls.setup({
    handlers = {},
    ensure_installed = {
      "black",
      "stylua",
      "xmlformatter",
      "shellharden",
      "cmakelang",
      "cmakelint",
      "markdownlint",
      "yamllint",
      "yamlfmt",
      "phpcs",
      "php-cs-fixer",
      "hadolint",
      "cpplint",
      "bash-debug-adapter",
      "pylint",
      "commitlint",
      "beautysh",
      "sql_formatter",
      "prettierd",
      "ktlint",
    },
    automatic_installation = true,
  })
end
