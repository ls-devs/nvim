-- Package required for :
-- Neorg
-- Rest.nvim
-- Nvim-Spider
-- Molten.nvim

return {
	"vhyrro/luarocks.nvim",
	priority = 1000,
	opts = {
		rocks = {
			"luautf8", -- Nvim-Spider
			"lua-utils.nvim", -- Neorg
			"lua-curl", -- Rest.nvim
			"nvim-nio", -- Rest.nvim
			"mimetypes", -- Rest.nvim
			"xml2lua", -- Rest.nvim
			"magick", -- Molten.nvim
		},
	},
}
