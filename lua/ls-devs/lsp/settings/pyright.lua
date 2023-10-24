return {
  single_file_support = true,
  settings = {
    python = {
      analysis = {
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        autoSearchPaths = true,
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
    },
  },
}
