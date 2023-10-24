local schemastore = require("schemastore")

return {
  json = {
    schemas = schemastore.json.schemas(),
    validate = { enable = true },
  },
}
