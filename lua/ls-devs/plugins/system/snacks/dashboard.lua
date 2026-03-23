---@diagnostic disable: undefined-global
-- ── snacks/dashboard.lua ─────────────────────────────────────────────────
-- Dashboard opts for snacks.nvim.
-- Loaded via require() from snacks.lua — NOT auto-imported by lazy.nvim.
-- Header ASCII art is injected at runtime in snacks.lua config() so the
-- Neovim version string is current.
-- Icons and key layout match the original alpha.lua dashboard buttons.
-- ─────────────────────────────────────────────────────────────────────────
---@type table
return {
	preset = {
		-- Header is set at runtime in snacks.lua config() with the live version.
		header = "",
		-- Preset keys: e/f/t/r/l/m/q — same shortcuts as the original alpha.lua layout.
		keys = {
			{
				icon = "󰙅 ",
				key = "e",
				desc = "File System",
				action = function()
					vim.cmd("Neotree float")
				end,
			},
			{
				icon = " ",
				key = "f",
				desc = "Find File",
				action = function()
					Snacks.picker.files()
				end,
			},
			{
				icon = " ",
				key = "t",
				desc = "Find Text",
				action = function()
					Snacks.picker.grep()
				end,
			},
			{
				icon = " ",
				key = "r",
				desc = "Recent Files",
				action = function()
					Snacks.picker.recent({ filter = { cwd = true } })
				end,
			},
			{
				icon = "󰒲 ",
				key = "l",
				desc = "Lazy",
				action = function()
					vim.cmd("Lazy")
				end,
			},
			{
				icon = "󱧕 ",
				key = "m",
				desc = "Mason",
				action = function()
					vim.cmd("Mason")
				end,
			},
			{
				icon = " ",
				key = "q",
				desc = "Quit",
				action = function()
					vim.cmd("qa")
				end,
			},
		},
	},
	sections = {
		{ section = "header" },
		{ section = "keys", gap = 1, padding = 1 },
		{ section = "startup" },
	},
}
