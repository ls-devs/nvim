local lspconfig_util = require("lspconfig.util")

if not lspconfig_util then
	return
end

return {
	root_dir = lspconfig_util.find_git_ancestor,
}
