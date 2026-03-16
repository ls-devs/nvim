return {
  -- on_init = function(client)
  --   client.config.settings.python.pythonPath =
  --     require("ls-devs.utils.custom_functions").get_python_path(client.config.root_dir)
  -- end,
  capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  ),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
