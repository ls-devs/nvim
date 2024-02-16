return {
	"gregorias/coerce.nvim",
	config = function()
		require("coerce").setup({
			keymap_registry = require("coerce.keymap").keymap_registry(),
			cases = require("coerce").default_cases,
			selection_modes = require("coerce").selection_modes,
		})
	end,
	keys = {
		{ "crc", desc = "Coerce CamelCase" },
		{ "crd", desc = "Coerce Dot.Case" },
		{ "crk", desc = "Coerce Kebab-Case" },
		{ "crn", desc = "Coerce N12E" },
		{ "crp", desc = "Coerce PascalCase" },
		{ "crs", desc = "Coerce Snake_Case" },
		{ "cru", desc = "Coerce UPPERCASE" },
		{ "cr/", desc = "Coerce Path/Case" },
	},
}
