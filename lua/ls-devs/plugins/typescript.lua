local M = {}

M.config = function()
  require("typescript").setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = true,          -- enable debug logging for commands
    go_to_source_definition = {
      fallback = true,      -- fall back to standard LSP definition on failure
    },
    server = {
      -- pass options to lspconfig's setup method
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentFormattingRangeProvider = false
      end,
    },
  })
end

return M
