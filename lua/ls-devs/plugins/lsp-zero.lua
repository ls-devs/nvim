local M = {}

M.config = function()
  local lsp_zero = require("lsp-zero")
  local ih = require("lsp-inlayhints")

  require("lspconfig.ui.windows").default_options.border = "rounded"

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

  lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  local get_servers = require("mason-lspconfig").get_installed_servers
  for _, server in pairs(get_servers()) do
    local has_config, config = pcall(require, "ls-devs.lsp.settings." .. server)
    if has_config then
      require("lspconfig")[server].setup({
        single_file_support = false,
        root_dir = require("lspconfig.util").root_pattern("."),
        on_attach = function(client, bufnr)
          ih.on_attach(client, bufnr)
        end,
        settings = config,
      })
    end
  end
end

return M
