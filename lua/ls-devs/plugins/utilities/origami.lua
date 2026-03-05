return {
	"chrisgrieser/nvim-origami",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		pauseFoldsOnSearch = true,
		foldKeymaps = {
			setup = true,
		},
	},
}
