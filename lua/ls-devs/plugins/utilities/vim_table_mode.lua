return {
	"dhruvasagar/vim-table-mode",
	cmd = "TableModeToggle",
	init = function()
		vim.g.table_mode_disable_mappings = true
	end,
}
