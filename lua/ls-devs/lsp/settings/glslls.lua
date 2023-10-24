return {
  root_dir = require("lspconfig.util").root_pattern("."),
  settings = {
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    single_file_support = true,
    filetypes = {
      "glsl",
      "vert",
      "frag",
    },
  },
}
