return {
	"chrisgrieser/nvim-origami",
	event = "BufReadPost", -- later or on keypress would prevent saving folds
	opts = {
		keepFoldsAcrossSessions = false,
		pauseFoldsOnSearch = true,
		setupFoldKeymaps = true,
	},
}
