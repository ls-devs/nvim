return {
	"David-Kunz/cmp-npm",
	dependencies = { "plenary.nvim", lazy = true },
	event = {
		"BufReadPost package.json",
		"BufNewFile package.json",
	},
	opts = {
		only_semantic_versions = false,
		only_latest_version = false,
	},
}
