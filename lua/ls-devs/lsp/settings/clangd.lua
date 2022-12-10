return {
	cmd = { "clangd", "--inlay-hints=true" },
	settings = {
		Configuration = {
			InlayHints = {
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
			},
		},
	},
}
