return {
	"chrisgrieser/nvim-origami",
	event = { "BufReadPost", "BufNewFile" }, -- later or on keypress would prevent saving folds
	opts = {
		keepFoldsAcrossSessions = false,
		pauseFoldsOnSearch = true,
		foldKeymaps = {
			setup = true,
		},
	},
}
