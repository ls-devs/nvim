return {
	"chrisgrieser/nvim-early-retirement",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		retirementAgeMins = 9,
		ignoredFiletypes = {
			"OverseerList",
		},
		ignoreFilenamePattern = "",
		ignoreAltFile = true,
		minimumBufferNum = 1,
		ignoreUnsavedChangesBufs = true,
		ignoreSpecialBuftypes = true,
		ignoreVisibleBufs = true,
		ignoreUnloadedBufs = false,
		notificationOnAutoClose = false,
		deleteBufferWhenFileDeleted = false,
	},
}
