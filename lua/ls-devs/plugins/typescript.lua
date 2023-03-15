local M = {}

M.config = function()
  local lsp = require("lsp-zero")

  local tsserver_opts = lsp.build_options("tsserver", {
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      vim.keymap.set("n", "<leader>ci", "<cmd>TypescriptOrganizeImports<cr>", { buffer = bufnr })
    end,
  })
  require("typescript").setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false,          -- enable debug logging for commands
    go_to_source_definition = {
      fallback = true,      -- fall back to standard LSP definition on failure
    },
    server = tsserver_opts,
  })
end

return M
