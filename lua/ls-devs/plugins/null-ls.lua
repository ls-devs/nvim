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
      null_ls.builtins.diagnostics.pylint,
      null_ls.builtins.formatting.black,
      -- JS / TS
      null_ls.builtins.code_actions.eslint_d,
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.formatting.prettier_d_slim.with({
        root_dir = require("null-ls.utils").root_pattern("."),
      }),
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
      null_ls.builtins.formatting.rustfmt.with({
        extra_args = function(params)
          local Path = require("plenary.path")
          local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

          if cargo_toml:exists() and cargo_toml:is_file() then
            for _, line in ipairs(cargo_toml:readlines()) do
              local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
              if edition then
                return { "--edition=" .. edition }
              end
            end
          end
          -- default edition when we don't find `Cargo.toml` or the `edition` in it.
          return { "--edition=2021" }
        end,
      }),
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
      null_ls.builtins.diagnostics.phpcs.with({
        extra_args = { "--standard=ruleset.xml" },
      }),
      null_ls.builtins.formatting.phpcsfixer,
      -- SQL
      null_ls.builtins.formatting.sql_formatter,
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
      -- CPP
      null_ls.builtins.diagnostics.cpplint.with({
        filetypes = { "c", "cpp" },
        extra_args = { "--filter=", "-legal/copyright" },
      }),
      null_ls.builtins.formatting.clang_format.with({
        filetypes = { "c", "cpp" },
        extra_args = { "-style=", "file" },
      }),
      -- GIT
      null_ls.builtins.diagnostics.commitlint,
      -- ZSH
      null_ls.builtins.formatting.beautysh.with({
        filetypes = { "zsh" },
      }),
    },
  })
end

return M
