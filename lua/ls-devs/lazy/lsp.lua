local M = {}

M.config = function()
  require("mason.settings").set({
    ui = {
      border = "rounded",
    },
  })

  require("lspconfig.ui.windows").default_options.border = "rounded"

  local lsp = require("lsp-zero")

  local lspkind = require("lspkind")

  local luasnip_vscode_loader = require("luasnip/loaders/from_vscode")

  lsp.preset("recommended")

  lsp.ensure_installed({
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
  })

  luasnip_vscode_loader.lazy_load()

  lsp.setup_nvim_cmp({
    preselect = require("cmp").PreselectMode.None,
    completion = {
      completeopt = "menu,menuone,noinsert,noselect",
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = 50,
        before = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      }),
    },
  })

  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minmal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  lsp.preset("recommended")

  lsp.on_attach(function(client, bufnr)
    require("lsp-inlayhints").on_attach(client, bufnr)
  end)

  local get_servers = require("mason-lspconfig").get_installed_servers
  for _, server in pairs(get_servers()) do
    local config_exists, config = pcall(require, "ls-devs.lsp.settings." .. server)
    if config_exists then
      lsp.configure(server, config)
    end
  end

  lsp.nvim_workspace()

  lsp.skip_server_setup({ "rust_analyzer" })

  lsp.setup()

  -- Autocmd for stopping eslint_d & prettier_d when leaving nvim
  vim.cmd("autocmd ExitPre *.jsx,*.tsx,*.vue,*.js,*.ts silent! !eslint_d stop")
  vim.cmd("autocmd ExitPre *.jsx,*.tsx,*.vue,*.js,*.ts silent! !prettierd stop")
end

return M
