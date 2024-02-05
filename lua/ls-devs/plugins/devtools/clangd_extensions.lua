return {
	"p00f/clangd_extensions.nvim",
	event = { "BufReadPost *.cpp *.c" },
	opts = {
		server = {
			on_attach = function(client, bufnr)
				client.server_capabilities.semanticTokensProvider = false
			end,
		},
		extensions = {
			ast = {
				role_icons = {
					type = "🄣",
					declaration = "🄓",
					expression = "🄔",
					statement = ";",
					specifier = "🄢",
					["template argument"] = "🆃",
				},
				kind_icons = {
					Compound = "🄲",
					Recovery = "🅁",
					TranslationUnit = "🅄",
					PackExpansion = "🄿",
					TemplateTypeParm = "🅃",
					TemplateTemplateParm = "🅃",
					TemplateParamObject = "🅃",
				},
			},
			memory_usage = {
				border = "none",
			},
			symbol_info = {
				border = "none",
			},
		},
	},
}
