return {
	"chrisgrieser/nvim-origami",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		keepFoldsAcrossSessions = false,
		pauseFoldsOnSearch = true,
		foldKeymaps = {
			setup = true,
		},
	},
}
