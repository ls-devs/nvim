return {
	"echasnovski/mini.surround",
	opts = {
		mappings = {
			add = "gza",
			delete = "gzd",
			find = "gzf",
			find_left = "gzF",
			highlight = "gzh",
			replace = "gzr",
			update_n_lines = "gzn",
		},
	},
	keys = { { "gz", mode = { "n", "v" }, desc = "Surround", noremap = true, silent = true } },
}
