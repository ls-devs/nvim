return {
  -- on_init = function(client)
  --   client.config.settings.python.pythonPath =
  --     require("ls-devs.utils.custom_functions").get_python_path(client.config.root_dir)
  -- end,
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
