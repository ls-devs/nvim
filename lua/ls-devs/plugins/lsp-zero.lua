local M = {}

M.config = function()
  require("lspconfig.ui.windows").default_options.border = "rounded"

  local lsp = require("lsp-zero").preset({
    name = "recommended",
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

  lsp.on_attach(function(client, bufnr)
    require("lsp-inlayhints").on_attach(client, bufnr)
    if client.server_capabilities["documentSymbolProvider"] then
      require("nvim-navic").attach(client, bufnr)
      if client.name == "volar" or client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
      end
    end
  end)

  local get_servers = require("mason-lspconfig").get_installed_servers
  for _, server in pairs(get_servers()) do
    local has_config, config = pcall(require, "ls-devs.lsp.settings." .. server)
    if has_config then
      require("lspconfig")[server].setup(config)
    end
  end

  lsp.nvim_workspace()

  lsp.setup()

  -- Autocmd for stopping eslint_d & prettier_d_slim when leaving nvim
  vim.cmd("autocmd VimLeave *.jsx,*.tsx,*.vue,*.js,*.ts silent !eslint_d stop")
  vim.cmd("autocmd VimLeave *.jsx,*.tsx,*.vue,*.js,*.ts silent !prettier_d_slim stop")
end

return M
