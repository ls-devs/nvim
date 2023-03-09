local M = {}

M.config = function()
  local treesitter = require("nvim-treesitter.configs")

  if not treesitter then
    return
  end

  treesitter.setup({
    ensure_installed = {
      "lua",
      "markdown",
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "prisma",
      "json",
      "svelte",
      "scss",
      "c",
      "python",
      "pug",
      "php",
      "java",
      "astro",
      "vue",
      "dockerfile",
      "graphql",
      "yaml",
      "toml",
      "rust",
      "http",
      "cpp",
      "markdown_inline",
      "regex",
      "bash",
      "cmake",
      "http",
      "gitcommit",
      "gitignore",
      "git_rebase",
      "gitattributes",
      "glsl",
      "hlsl",
      "wgsl",
      "go",
      "make",
      "gomod",
      "haskell",
      "graphql",
      "v",
    },
    sync_install = true,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
    },
    autotag = {
      enable = true,
    },
    indent = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        },
        selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
        },
        include_surrounding_whitespace = true,
      },
      swap = {
        enable = true,
        swap_next = {
              ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
              ["<leader>A"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
        },
        goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
        },
        goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
        },
        goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
        },
      },
    },
  })

  vim.cmd([[hi rainbowcol1 guifg=#7f849c]])
end

return M
