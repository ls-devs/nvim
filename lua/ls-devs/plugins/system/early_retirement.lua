-- ── early-retirement ──────────────────────────────────────────────────────
-- Purpose : Auto-closes idle buffers after 9 minutes of inactivity
-- Trigger : BufReadPost, BufNewFile
-- Note    : minimumBufferNum=1 ensures at least one buffer always stays open
-- ─────────────────────────────────────────────────────────────────────────
---@type LazySpec
return {
	"chrisgrieser/nvim-early-retirement",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		retirementAgeMins = 9, -- close buffers idle for more than this many minutes
		ignoredFiletypes = {
			"OverseerList", -- task runner panel: don't auto-close mid-task
			"neo-tree", -- file explorer: buftype="" so ignoreSpecialBuftypes won't catch it
		},
		ignoreFilenamePattern = "",
		ignoreAltFile = true, -- preserve the alternate file (#) from retirement
		minimumBufferNum = 1, -- never close the very last open buffer
		ignoreUnsavedChangesBufs = true,
		ignoreSpecialBuftypes = true,
		ignoreVisibleBufs = true,
		ignoreUnloadedBufs = false, -- unloaded-but-listed buffers are eligible for retirement
		notificationOnAutoClose = false,
		deleteBufferWhenFileDeleted = false,
	},
}
