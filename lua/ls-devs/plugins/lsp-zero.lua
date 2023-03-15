local M = {}

M.config = function()
  require("lspconfig.ui.windows").default_options.border = "rounded"

  local lsp = require("lsp-zero").preset({
    name = "lsp-compe",
    manage_nvim_cmp = false,
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

  lsp.skip_server_setup({ "rust_analyzer" })
  lsp.skip_server_setup({ "volar" })
  lsp.skip_server_setup({ "tsserver" })

  lsp.on_attach(function(client, bufnr)
    require("lsp-inlayhints").on_attach(client, bufnr)
    if client.server_capabilities["documentSymbolProvider"] then
      require("nvim-navic").attach(client, bufnr)
    end
  end)

  local get_servers = require("mason-lspconfig").get_installed_servers
  for _, server in pairs(get_servers()) do
    local config_exists, config = pcall(require, "ls-devs.lsp.settings." .. server)
    if config_exists then
      lsp.configure(server, config)
      if server == "volar" then
        lsp.build_options("volar", {
          on_attach = function(client)
            client.server_capabilities.document_formatting = false
          end,
        })
      end
    end
  end
  lsp.nvim_workspace()

  lsp.setup()

  -- Autocmd for stopping eslint_d & prettier_d when leaving nvim
  vim.cmd("autocmd ExitPre *.jsx,*.tsx,*.vue,*.js,*.ts !eslint_d stop")
  vim.cmd("autocmd ExitPre *.jsx,*.tsx,*.vue,*.js,*.ts !prettier_d_slim stop")
end

return M
