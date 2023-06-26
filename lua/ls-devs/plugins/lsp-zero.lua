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
  lsp.skip_server_setup({ "hls" })
  lsp.skip_server_setup({ "clangd" })
  lsp.skip_server_setup({ "tsserver" })

  lsp.on_attach(function(client, bufnr)
    require("lsp-inlayhints").on_attach(client, bufnr)
    if client.name == "volar" or client.name == "tsserver" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentFormattingRangeProvider = false
    end
    -- if client.name == "clangd" then
    --   client.server_capabilities.semanticTokensProvider = false
    -- end
  end)

  require("lspconfig").glslls.setup(require("ls-devs.lsp.settings.glslls"))

  local get_servers = require("mason-lspconfig").get_installed_servers
  for _, server in pairs(get_servers()) do
    local has_config, config = pcall(require, "ls-devs.lsp.settings." .. server)
    if has_config then
      require("lspconfig")[server].setup(config)
    end
  end

  lsp.nvim_workspace()

  lsp.setup()

  -- vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
  --   config = config or {}
  --   config.focus_id = ctx.method
  --   if not (result and result.contents) then
  --     return
  --   end
  --   config.border = "rounded"
  --   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  --   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  --   if vim.tbl_isempty(markdown_lines) then
  --     return
  --   end
  --   return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
  -- end
end

return M
