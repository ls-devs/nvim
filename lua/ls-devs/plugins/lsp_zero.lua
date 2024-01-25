local M = {}

M.config = function()
  local lsp_zero = require("lsp-zero")

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

  ---@diagnostic disable-next-line: unused-local
  lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  ---@diagnostic disable-next-line: different-requires
  local get_servers = require("mason-lspconfig").get_installed_servers
  for _, server in pairs(get_servers()) do
    local has_config, config = pcall(require, "ls-devs.lsp.settings." .. server)
    if has_config then
      require("lspconfig")[server].setup(config)
    end
  end

  -- TODO: Check if usefull
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
